/ use timespan with kdb+tick v2.5 or higher. Prior versions use time type
quote:([]time:`timespan$();sym:`symbol$();bid:`float$();ask:`float$())
trade:([]time:`timespan$();sym:`symbol$();price:`float$();buy:`boolean$())
