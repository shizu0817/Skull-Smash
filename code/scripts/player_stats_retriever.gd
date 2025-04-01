class_name PlayerStatsRetriever
extends Resource


@export var player_stats: Array[PlayerStats]


func get_stats(level: int) -> PlayerStats:
	for stats in player_stats:
		if stats.level == level:
			return stats

	return null


func get_initial_stats() -> PlayerStats:
	var initial_stats: PlayerStats = null

	for stats in player_stats:
		if initial_stats == null:
			initial_stats = stats
		elif stats.level < initial_stats.level:
			initial_stats = stats

	return initial_stats
