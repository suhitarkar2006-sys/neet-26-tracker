-- NEET 2027 persistent study timer
-- Run this once in Supabase SQL Editor.

create table if not exists public.study_timer (
  user_id uuid primary key references auth.users(id) on delete cascade,
  total_seconds bigint not null default 0,
  active_started_at timestamptz,
  active_elapsed_before bigint not null default 0,
  history jsonb not null default '[]'::jsonb
);

alter table public.study_timer enable row level security;

drop policy if exists "study_timer_select_own" on public.study_timer;
create policy "study_timer_select_own"
on public.study_timer for select
using (auth.uid() = user_id);

drop policy if exists "study_timer_insert_own" on public.study_timer;
create policy "study_timer_insert_own"
on public.study_timer for insert
with check (auth.uid() = user_id);

drop policy if exists "study_timer_update_own" on public.study_timer;
create policy "study_timer_update_own"
on public.study_timer for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "study_timer_delete_own" on public.study_timer;
create policy "study_timer_delete_own"
on public.study_timer for delete
using (auth.uid() = user_id);
