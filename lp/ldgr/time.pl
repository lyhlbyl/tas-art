%% context setting for time
#const max_timestamp_count=20.
#const count_per_sec=2.
timestamp(0..max_timestamp_count).
time(TC/2) :- timestamp(TC).
