-- ============================================================================
-- StrangleThorn Vale Boundary Refinement
-- ============================================================================
-- Date: 2026-01-27
-- Purpose: Correct zone boundaries after discovering initial range included
--          multiple adjacent zones (Blasted Lands, Westfall)
-- ============================================================================

-- INITIAL ATTEMPT (INCORRECT)
-- X: -14600 to -10300, Y: -4200 to 1600
-- Result: 4,160 creatures (contaminated with Nethergarde, demons, etc.)

-- DISCOVERY PROCESS
-- Used known STV landmarks to find true coordinates

-- Find Booty Bay Bruiser (100% STV-specific)
SELECT 
    ct.name,
    AVG(c.position_x) as avg_x,
    AVG(c.position_y) as avg_y,
    MIN(c.position_x) as min_x,
    MAX(c.position_x) as max_x,
    MIN(c.position_y) as min_y,
    MAX(c.position_y) as max_y,
    COUNT(*) as spawn_count
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 0
  AND ct.name IN (
    'Booty Bay Bruiser',
    'Skullsplitter Warrior',
    'Bloodscalp Scout',
    'Jungle Stalker',
    'Stranglethorn Tigress'
  )
GROUP BY ct.name;

-- Results showed TRUE STV range:
-- X: approximately -14488 to -12036
-- Y: approximately -987 to 1267

-- CORRECTED BOUNDARIES
-- X: -14500 to -11500 (safety margin)
-- Y: -1100 to 1300 (safety margin)

-- VERIFICATION QUERY
SELECT 
    COUNT(*) as creature_count,
    MIN(position_x) AS min_x,
    MAX(position_x) AS max_x,
    MIN(position_y) AS min_y,
    MAX(position_y) AS max_y,
    MIN(position_z) AS min_z,
    MAX(position_z) AS max_z
FROM creature
WHERE map = 0
  AND position_x BETWEEN -14500 AND -11500
  AND position_y BETWEEN -1100 AND 1300;

-- Result: 1,572 creatures (clean STV data)
-- Actual coordinates: X[-14491.6, -11503.3], Y[-1094.62, 1295.52]

-- CREATURE DISTRIBUTION (Top 30)
SELECT 
    ct.entry,
    ct.name,
    ct.minlevel,
    ct.maxlevel,
    COUNT(*) as spawn_count
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 0
  AND c.position_x BETWEEN -14500 AND -11500
  AND c.position_y BETWEEN -1100 AND 1300
GROUP BY ct.entry, ct.name, ct.minlevel, ct.maxlevel
ORDER BY spawn_count DESC
LIMIT 30;

-- All results verified as authentic STV content:
-- Booty Bay NPCs, Bloodscalp trolls, Skullsplitter trolls,
-- Venture Co. goblins, jungle wildlife, Naga, Kurzen compound

-- ============================================================================
-- FINAL BOUNDARIES FOR ALL FUTURE QUERIES
-- ============================================================================
-- Use these coordinates for all STV analysis:
-- WHERE map = 0
--   AND position_x BETWEEN -14500 AND -11500
--   AND position_y BETWEEN -1100 AND 1300
-- ============================================================================

-- LESSONS LEARNED
-- 1. Validate assumptions with known landmarks
-- 2. Initial generous boundaries captured adjacent zones
-- 3. Ground truth (known STV creatures) > assumptions
-- 4. Iterative refinement essential when initial data suspect
-- ============================================================================