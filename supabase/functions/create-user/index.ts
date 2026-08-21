// supabase/functions/create-user/index.ts
//
// Supabase Edge Function — Create User
// Called by the Flutter admin panel to create a new Supabase Auth user.
// Uses the service_role key (server-side only — never expose in Flutter).
//
// Request body: { email, password, role, employee_id, full_name? }
// Response:     { user_id: string } or { error: string }

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Parse request body
    const { email, password, role, full_name, employee_id } = await req.json();

    // Validate required fields
    if (!email || !password || !role || !employee_id) {
      return new Response(
        JSON.stringify({
          error: "email, password, role and employee_id are required.",
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    if (password.length < 6) {
      return new Response(
        JSON.stringify({ error: "Password must be at least 6 characters." }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Normalise employee_id — always store UPPERCASE
    const normalisedEmployeeId = (employee_id as string).trim().toUpperCase();

    // Validate format: must be RIV + exactly 3 digits
    const employeeIdRegex = /^RIV\d{3}$/;
    if (!employeeIdRegex.test(normalisedEmployeeId)) {
      return new Response(
        JSON.stringify({
          error:
            "Employee ID must be in format RIV followed by 3 digits (e.g. RIV001).",
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Create admin client with service_role key
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      }
    );

    // Check if employee_id already exists (avoid duplicate before auth creation)
    const { data: existing } = await supabaseAdmin
      .from("profiles")
      .select("id")
      .eq("employee_id", normalisedEmployeeId)
      .limit(1);

    if (existing && existing.length > 0) {
      return new Response(
        JSON.stringify({
          error: `Employee ID '${normalisedEmployeeId}' is already assigned to another user.`,
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Step 1: Create the auth user (email_confirm: true skips confirmation email)
    const { data: authData, error: authError } =
      await supabaseAdmin.auth.admin.createUser({
        email: email.trim().toLowerCase(),
        password,
        email_confirm: true,
        user_metadata: {
          full_name: full_name ?? email.split("@")[0],
        },
      });

    if (authError) {
      return new Response(
        JSON.stringify({ error: authError.message }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    const userId = authData.user?.id;
    if (!userId) {
      return new Response(
        JSON.stringify({ error: "User created but ID not returned." }),
        {
          status: 500,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    // Step 2: Update the profile row auto-created by the DB trigger.
    // Set role AND employee_id.
    const { error: profileError } = await supabaseAdmin
      .from("profiles")
      .update({
        role: role,
        employee_id: normalisedEmployeeId,
      })
      .eq("id", userId);

    if (profileError) {
      // Non-fatal: user was created in auth, but profile update failed.
      return new Response(
        JSON.stringify({
          user_id: userId,
          warning: `User created but profile update failed: ${profileError.message}`,
        }),
        {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    return new Response(
      JSON.stringify({ user_id: userId }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: `Unexpected error: ${e}` }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
