-- NEET 2027 Aakash Exam Tracker
-- Run this once in Supabase SQL Editor.

create table if not exists public.exam_results (
  user_id uuid not null references auth.users(id) on delete cascade,
  exam_id text not null,
  physics_correct integer,
  physics_wrong integer,
  physics_missed integer,
  chemistry_correct integer,
  chemistry_wrong integer,
  chemistry_missed integer,
  botany_correct integer,
  botany_wrong integer,
  botany_missed integer,
  zoology_correct integer,
  zoology_wrong integer,
  zoology_missed integer,
  rank integer,
  percentile numeric(6,2),
  updated_at timestamptz not null default now(),
  primary key (user_id, exam_id),
  constraint exam_subject_counts check (
    physics_correct between 0 and 45 and physics_wrong between 0 and 45 and physics_missed between 0 and 45 and
    chemistry_correct between 0 and 45 and chemistry_wrong between 0 and 45 and chemistry_missed between 0 and 45 and
    botany_correct between 0 and 45 and botany_wrong between 0 and 45 and botany_missed between 0 and 45 and
    zoology_correct between 0 and 45 and zoology_wrong between 0 and 45 and zoology_missed between 0 and 45
  )
);

alter table public.exam_results enable row level security;

drop policy if exists "exam_results_select_own" on public.exam_results;
create policy "exam_results_select_own"
on public.exam_results for select
using (auth.uid() = user_id);

drop policy if exists "exam_results_insert_own" on public.exam_results;
create policy "exam_results_insert_own"
on public.exam_results for insert
with check (auth.uid() = user_id);

drop policy if exists "exam_results_update_own" on public.exam_results;
create policy "exam_results_update_own"
on public.exam_results for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "exam_results_delete_own" on public.exam_results;
create policy "exam_results_delete_own"
on public.exam_results for delete
using (auth.uid() = user_id);

create or replace function public.set_exam_results_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists exam_results_updated_at on public.exam_results;
create trigger exam_results_updated_at
before update on public.exam_results
for each row execute function public.set_exam_results_updated_at();
