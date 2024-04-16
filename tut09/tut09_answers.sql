-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- Question1.
SELECT player_name
FROM player
WHERE batting_hand = 'Left-hand bat' AND country_name = 'England'
ORDER BY player_name;

-- Question2. 
SELECT 
    player_name,
    TIMESTAMPDIFF(YEAR, dob, '2018-12-02') AS age
FROM 
    player
WHERE 
    bowling_skill = 'Legbreak googly'
    AND TIMESTAMPDIFF(YEAR, dob, '2018-12-02') >= 28
ORDER BY 
    age DESC,
    player_name;

-- Question3.
SELECT match_id, toss_winner
FROM matches
WHERE toss_decision = 'bat'
ORDER BY match_id;

-- Question4. 
SELECT over_id, runs_scored
FROM batsman_scored
WHERE match_id = 335987 AND runs_scored <= 7
ORDER BY runs_scored DESC, over_id;

-- Question5. 
SELECT DISTINCT player.player_name
FROM player
JOIN wickets ON player.player_id = wickets.player_out
WHERE wickets.kind_out = 'Bowled'
ORDER BY player.player_name;

-- Question6.
SELECT matches.match_id, 
       Team1.name AS team_1, 
       Team2.name AS team_2, 
       WinningTeam.name AS winning_team_name, 
       matches.win_margin
FROM matches
JOIN team AS Team1 ON matches.team_1 = Team1.team_id
JOIN team AS Team2 ON matches.team_2 = Team2.team_id
JOIN team AS WinningTeam ON matches.match_winner = WinningTeam.team_id
WHERE matches.win_margin >= 60
ORDER BY matches.win_margin, matches.match_id;

-- Question7.
SELECT player_name 
FROM player 
WHERE batting_hand = 'Left-hand bat' 
AND dob >= '1988-12-02'
ORDER BY player_name;

-- Question8.
SELECT match_id, SUM(runs_scored) AS total_runs
FROM batsman_scored
GROUP BY match_id
ORDER BY match_id;

-- Question9.
SELECT 
    r.match_id,
    MAX(r.runs_scored) AS maximum_runs,
    p.player_name
FROM 
    batsman_scored r
JOIN 
    ball_by_ball b ON r.match_id = b.match_id AND r.over_id = b.over_id
JOIN 
    player p ON b.bowler = p.player_id
GROUP BY 
    r.match_id
ORDER BY 
    r.match_id;

-- Question10.
SELECT player.player_name, COUNT(wickets.kind_out) AS number
FROM wickets
JOIN player ON wickets.player_out = player.player_id
WHERE wickets.kind_out = 'run out'
GROUP BY wickets.player_out
ORDER BY number DESC, player.player_name;

-- Question11.
SELECT kind_out AS out_type, COUNT(kind_out) AS number
FROM wickets
GROUP BY kind_out
ORDER BY number DESC, kind_out;

-- Question12.
SELECT team.name, COUNT(matches.man_of_the_match) AS number
FROM matches
JOIN team ON matches.man_of_the_match = team.team_id
GROUP BY team.name
ORDER BY team.name;

-- Question13.
SELECT venue
FROM (
    SELECT venue, ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC, venue) AS row_num
    FROM extra_runs JOIN matches ON matches.match_id = extra_runs.match_id
    WHERE extra_type = 'wides'
    GROUP BY venue
) AS sub
WHERE row_num = 1;

-- Question14.
SELECT venue
FROM (
    SELECT venue, COUNT(*) AS wins
    FROM matches JOIN ball_by_ball ON matches.match_id = ball_by_ball.match_id
    WHERE ball_by_ball.team_bowling = match_winner AND toss_decision = 'field'
    GROUP BY venue
    ORDER BY wins DESC, venue
) AS bowling_wins;

-- Question15.
SELECT 
    p.player_name
FROM 
    player p
JOIN 
    (
        SELECT 
            b.bowler AS player_id,
            SUM(p.runs_scored) AS total_runs_given,
            COUNT(po.player_out) AS total_wickets_taken
        FROM 
            ball_by_ball b JOIN batsman_scored p
        LEFT JOIN 
            wickets po ON b.match_id = po.match_id
                         AND b.over_id = po.over_id
                         AND b.ball_id = po.ball_id
                         AND b.innings_no = po.innings_no
        WHERE 
            po.kind_out IS NOT NULL
        GROUP BY 
            b.bowler
    ) AS bowling_stats ON p.player_id = bowling_stats.player_id
ORDER BY 
    (bowling_stats.total_runs_given / NULLIF(bowling_stats.total_wickets_taken, 0)),
    p.player_name
LIMIT 1;

-- Question16.
SELECT player.player_name, team.name
FROM player
JOIN player_match ON player.player_id = player_match.player_id
JOIN team ON player_match.team_id = team.team_id
JOIN matches ON player_match.match_id = matches.match_id
WHERE player_match.role = 'CaptainKeeper' AND matches.match_winner = player_match.team_id
ORDER BY player.player_name;

-- Question17. 
SELECT player.player_name, SUM(batsman_scored.runs_scored) AS runs_scored
FROM player
JOIN ball_by_ball ON player.player_id = ball_by_ball.striker OR player.player_id = ball_by_ball.non_striker
JOIN batsman_scored ON ball_by_ball.match_id = batsman_scored.match_id AND ball_by_ball.innings_no = batsman_scored.innings_no AND ball_by_ball.over_id = batsman_scored.over_id AND ball_by_ball.ball_id = batsman_scored.ball_id
GROUP BY player.player_name
HAVING SUM(batsman_scored.runs_scored) >= 50
ORDER BY runs_scored DESC, player.player_name;

-- Question18.
SELECT player.player_name
FROM player
JOIN ball_by_ball ON player.player_id = ball_by_ball.striker OR player.player_id = ball_by_ball.non_striker
JOIN batsman_scored ON ball_by_ball.match_id = batsman_scored.match_id AND ball_by_ball.innings_no = batsman_scored.innings_no AND ball_by_ball.over_id = batsman_scored.over_id AND ball_by_ball.ball_id = batsman_scored.ball_id
JOIN matches ON ball_by_ball.match_id = matches.match_id
WHERE batsman_scored.runs_scored >= 100 AND matches.match_winner != ball_by_ball.team_batting
ORDER BY player.player_name;

-- Question19.
SELECT matches.match_id, matches.venue
FROM matches
JOIN team AS T1 ON matches.team_1 = T1.team_id
JOIN team AS T2 ON matches.team_2 = T2.team_id
WHERE (T1.name = 'KKR' OR T2.name = 'KKR') AND matches.match_winner != (SELECT team_id FROM team WHERE name = 'KKR')
ORDER BY matches.match_id;

-- Question20.
SELECT player.player_name
FROM player
JOIN player_match ON player.player_id = player_match.player_id
JOIN matches ON player_match.match_id = matches.match_id 
JOIN batsman_scored ON batsman_scored.match_id = matches.match_id
WHERE batsman_scored.innings_no <= 2
AND matches.season_id = 5
GROUP BY player.player_name
HAVING COUNT(player_match.match_id) > 0
ORDER BY (SUM(batsman_scored.runs_scored) / (COUNT(DISTINCT player_match.match_id))) DESC, player.player_name
LIMIT 10;
