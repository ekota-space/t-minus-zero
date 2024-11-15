create table "public"."OrganizationAdmins" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "organizationId" uuid not null,
    "profileId" uuid not null
);


create table "public"."OrganizationMembers" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "organizationId" uuid not null,
    "profileId" uuid not null
);


create table "public"."Organizations" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "ownerId" uuid not null,
    "slug" text not null
);


create table "public"."Profiles" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "firstName" text not null,
    "lastName" text not null,
    "username" text not null,
    "userId" uuid not null
);


create table "public"."ProjectManagers" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "projectId" uuid not null,
    "profileId" uuid not null
);


create table "public"."Projects" (
    "id" uuid not null default gen_random_uuid(),
    "createdAt" timestamp with time zone not null default now(),
    "name" text not null,
    "description" text,
    "slug" text not null,
    "organizationId" uuid not null
);


CREATE UNIQUE INDEX "OrganizationAdmins_pkey" ON public."OrganizationAdmins" USING btree (id);

CREATE UNIQUE INDEX "OrganizationMembers_organizationId_profileId_idx" ON public."OrganizationMembers" USING btree ("organizationId", "profileId");

CREATE UNIQUE INDEX "OrganizationMembers_pkey" ON public."OrganizationMembers" USING btree (id);

CREATE UNIQUE INDEX "Organization_pkey" ON public."Organizations" USING btree (id);

CREATE UNIQUE INDEX "Organization_slug_key" ON public."Organizations" USING btree (slug);

CREATE UNIQUE INDEX "Profile_pkey" ON public."Profiles" USING btree (id);

CREATE UNIQUE INDEX "Profile_username_key" ON public."Profiles" USING btree (username);

CREATE UNIQUE INDEX "ProjectManagers_pkey" ON public."ProjectManagers" USING btree (id);

CREATE UNIQUE INDEX "Projects_pkey" ON public."Projects" USING btree (id);

CREATE UNIQUE INDEX idx_unique_organization_admins ON public."OrganizationAdmins" USING btree ("organizationId", "profileId");

CREATE UNIQUE INDEX idx_unique_projects_slug ON public."Projects" USING btree ("organizationId", slug);

alter table "public"."OrganizationAdmins" add constraint "OrganizationAdmins_pkey" PRIMARY KEY using index "OrganizationAdmins_pkey";

alter table "public"."OrganizationMembers" add constraint "OrganizationMembers_pkey" PRIMARY KEY using index "OrganizationMembers_pkey";

alter table "public"."Organizations" add constraint "Organization_pkey" PRIMARY KEY using index "Organization_pkey";

alter table "public"."Profiles" add constraint "Profile_pkey" PRIMARY KEY using index "Profile_pkey";

alter table "public"."ProjectManagers" add constraint "ProjectManagers_pkey" PRIMARY KEY using index "ProjectManagers_pkey";

alter table "public"."Projects" add constraint "Projects_pkey" PRIMARY KEY using index "Projects_pkey";

alter table "public"."OrganizationAdmins" add constraint "OrganizationAdmins_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."OrganizationAdmins" validate constraint "OrganizationAdmins_organizationId_fkey";

alter table "public"."OrganizationAdmins" add constraint "OrganizationAdmins_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profiles"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."OrganizationAdmins" validate constraint "OrganizationAdmins_profileId_fkey";

alter table "public"."OrganizationMembers" add constraint "OrganizationMembers_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."OrganizationMembers" validate constraint "OrganizationMembers_organizationId_fkey";

alter table "public"."OrganizationMembers" add constraint "OrganizationMembers_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profiles"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."OrganizationMembers" validate constraint "OrganizationMembers_profileId_fkey";

alter table "public"."Organizations" add constraint "Organization_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "Profiles"(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."Organizations" validate constraint "Organization_ownerId_fkey";

alter table "public"."Organizations" add constraint "Organization_slug_key" UNIQUE using index "Organization_slug_key";

alter table "public"."Profiles" add constraint "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Profiles" validate constraint "Profile_userId_fkey";

alter table "public"."Profiles" add constraint "Profile_username_key" UNIQUE using index "Profile_username_key";

alter table "public"."Profiles" add constraint "profile_username_check" CHECK ((username ~ '^[a-z0-9_]{6,20}$'::text)) not valid;

alter table "public"."Profiles" validate constraint "profile_username_check";

alter table "public"."ProjectManagers" add constraint "ProjectManagers_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "Profiles"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."ProjectManagers" validate constraint "ProjectManagers_profileId_fkey";

alter table "public"."ProjectManagers" add constraint "ProjectManagers_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Projects"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."ProjectManagers" validate constraint "ProjectManagers_projectId_fkey";

alter table "public"."Projects" add constraint "Projects_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organizations"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Projects" validate constraint "Projects_organizationId_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_profile_id()
 RETURNS uuid
 LANGUAGE sql
 STABLE
AS $function$
  SELECT id FROM "Profiles" WHERE "userId" = auth.uid();
$function$
;

grant delete on table "public"."OrganizationAdmins" to "anon";

grant insert on table "public"."OrganizationAdmins" to "anon";

grant references on table "public"."OrganizationAdmins" to "anon";

grant select on table "public"."OrganizationAdmins" to "anon";

grant trigger on table "public"."OrganizationAdmins" to "anon";

grant truncate on table "public"."OrganizationAdmins" to "anon";

grant update on table "public"."OrganizationAdmins" to "anon";

grant delete on table "public"."OrganizationAdmins" to "authenticated";

grant insert on table "public"."OrganizationAdmins" to "authenticated";

grant references on table "public"."OrganizationAdmins" to "authenticated";

grant select on table "public"."OrganizationAdmins" to "authenticated";

grant trigger on table "public"."OrganizationAdmins" to "authenticated";

grant truncate on table "public"."OrganizationAdmins" to "authenticated";

grant update on table "public"."OrganizationAdmins" to "authenticated";

grant delete on table "public"."OrganizationAdmins" to "service_role";

grant insert on table "public"."OrganizationAdmins" to "service_role";

grant references on table "public"."OrganizationAdmins" to "service_role";

grant select on table "public"."OrganizationAdmins" to "service_role";

grant trigger on table "public"."OrganizationAdmins" to "service_role";

grant truncate on table "public"."OrganizationAdmins" to "service_role";

grant update on table "public"."OrganizationAdmins" to "service_role";

grant delete on table "public"."OrganizationMembers" to "anon";

grant insert on table "public"."OrganizationMembers" to "anon";

grant references on table "public"."OrganizationMembers" to "anon";

grant select on table "public"."OrganizationMembers" to "anon";

grant trigger on table "public"."OrganizationMembers" to "anon";

grant truncate on table "public"."OrganizationMembers" to "anon";

grant update on table "public"."OrganizationMembers" to "anon";

grant delete on table "public"."OrganizationMembers" to "authenticated";

grant insert on table "public"."OrganizationMembers" to "authenticated";

grant references on table "public"."OrganizationMembers" to "authenticated";

grant select on table "public"."OrganizationMembers" to "authenticated";

grant trigger on table "public"."OrganizationMembers" to "authenticated";

grant truncate on table "public"."OrganizationMembers" to "authenticated";

grant update on table "public"."OrganizationMembers" to "authenticated";

grant delete on table "public"."OrganizationMembers" to "service_role";

grant insert on table "public"."OrganizationMembers" to "service_role";

grant references on table "public"."OrganizationMembers" to "service_role";

grant select on table "public"."OrganizationMembers" to "service_role";

grant trigger on table "public"."OrganizationMembers" to "service_role";

grant truncate on table "public"."OrganizationMembers" to "service_role";

grant update on table "public"."OrganizationMembers" to "service_role";

grant delete on table "public"."Organizations" to "anon";

grant insert on table "public"."Organizations" to "anon";

grant references on table "public"."Organizations" to "anon";

grant select on table "public"."Organizations" to "anon";

grant trigger on table "public"."Organizations" to "anon";

grant truncate on table "public"."Organizations" to "anon";

grant update on table "public"."Organizations" to "anon";

grant delete on table "public"."Organizations" to "authenticated";

grant insert on table "public"."Organizations" to "authenticated";

grant references on table "public"."Organizations" to "authenticated";

grant select on table "public"."Organizations" to "authenticated";

grant trigger on table "public"."Organizations" to "authenticated";

grant truncate on table "public"."Organizations" to "authenticated";

grant update on table "public"."Organizations" to "authenticated";

grant delete on table "public"."Organizations" to "service_role";

grant insert on table "public"."Organizations" to "service_role";

grant references on table "public"."Organizations" to "service_role";

grant select on table "public"."Organizations" to "service_role";

grant trigger on table "public"."Organizations" to "service_role";

grant truncate on table "public"."Organizations" to "service_role";

grant update on table "public"."Organizations" to "service_role";

grant delete on table "public"."Profiles" to "anon";

grant insert on table "public"."Profiles" to "anon";

grant references on table "public"."Profiles" to "anon";

grant select on table "public"."Profiles" to "anon";

grant trigger on table "public"."Profiles" to "anon";

grant truncate on table "public"."Profiles" to "anon";

grant update on table "public"."Profiles" to "anon";

grant delete on table "public"."Profiles" to "authenticated";

grant insert on table "public"."Profiles" to "authenticated";

grant references on table "public"."Profiles" to "authenticated";

grant select on table "public"."Profiles" to "authenticated";

grant trigger on table "public"."Profiles" to "authenticated";

grant truncate on table "public"."Profiles" to "authenticated";

grant update on table "public"."Profiles" to "authenticated";

grant delete on table "public"."Profiles" to "service_role";

grant insert on table "public"."Profiles" to "service_role";

grant references on table "public"."Profiles" to "service_role";

grant select on table "public"."Profiles" to "service_role";

grant trigger on table "public"."Profiles" to "service_role";

grant truncate on table "public"."Profiles" to "service_role";

grant update on table "public"."Profiles" to "service_role";

grant delete on table "public"."ProjectManagers" to "anon";

grant insert on table "public"."ProjectManagers" to "anon";

grant references on table "public"."ProjectManagers" to "anon";

grant select on table "public"."ProjectManagers" to "anon";

grant trigger on table "public"."ProjectManagers" to "anon";

grant truncate on table "public"."ProjectManagers" to "anon";

grant update on table "public"."ProjectManagers" to "anon";

grant delete on table "public"."ProjectManagers" to "authenticated";

grant insert on table "public"."ProjectManagers" to "authenticated";

grant references on table "public"."ProjectManagers" to "authenticated";

grant select on table "public"."ProjectManagers" to "authenticated";

grant trigger on table "public"."ProjectManagers" to "authenticated";

grant truncate on table "public"."ProjectManagers" to "authenticated";

grant update on table "public"."ProjectManagers" to "authenticated";

grant delete on table "public"."ProjectManagers" to "service_role";

grant insert on table "public"."ProjectManagers" to "service_role";

grant references on table "public"."ProjectManagers" to "service_role";

grant select on table "public"."ProjectManagers" to "service_role";

grant trigger on table "public"."ProjectManagers" to "service_role";

grant truncate on table "public"."ProjectManagers" to "service_role";

grant update on table "public"."ProjectManagers" to "service_role";

grant delete on table "public"."Projects" to "anon";

grant insert on table "public"."Projects" to "anon";

grant references on table "public"."Projects" to "anon";

grant select on table "public"."Projects" to "anon";

grant trigger on table "public"."Projects" to "anon";

grant truncate on table "public"."Projects" to "anon";

grant update on table "public"."Projects" to "anon";

grant delete on table "public"."Projects" to "authenticated";

grant insert on table "public"."Projects" to "authenticated";

grant references on table "public"."Projects" to "authenticated";

grant select on table "public"."Projects" to "authenticated";

grant trigger on table "public"."Projects" to "authenticated";

grant truncate on table "public"."Projects" to "authenticated";

grant update on table "public"."Projects" to "authenticated";

grant delete on table "public"."Projects" to "service_role";

grant insert on table "public"."Projects" to "service_role";

grant references on table "public"."Projects" to "service_role";

grant select on table "public"."Projects" to "service_role";

grant trigger on table "public"."Projects" to "service_role";

grant truncate on table "public"."Projects" to "service_role";

grant update on table "public"."Projects" to "service_role";


