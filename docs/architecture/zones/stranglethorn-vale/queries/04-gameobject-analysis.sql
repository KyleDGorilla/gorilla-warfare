-- ============================================================================
-- StrangleThorn Vale Gameobject Analysis
-- ============================================================================
-- Date: 2026-01-27
-- Purpose: Analyze interactive objects, resource nodes, and quest objects
-- ============================================================================

-- GAMEOBJECT COUNT IN TRUE STV BOUNDARIES
SELECT 
    COUNT(*) as gameobject_count,
    MIN(position_x) AS min_x,
    MAX(position_x) AS max_x,
    MIN(position_y) AS min_y,
    MAX(position_y) AS max_y,
    MIN(position_z) AS min_z,
    MAX(position_z) AS max_z
FROM gameobject
WHERE map = 0
  AND position_x BETWEEN -14500 AND -11500
  AND position_y BETWEEN -1100 AND 1300;

-- Result: 1,979 gameobjects
-- Coordinates: X[-14488.5, -11501], Y[-1096.73, 1256.12], Z[-109.598, 140.341]

-- GAMEOBJECT TYPE DISTRIBUTION
-- Shows most common object types and their spawn counts
SELECT 
    got.entry,
    got.name,
    got.type,  -- Object type: 3=resource, 5=generic, 10=door, 25=fishing
    COUNT(*) as spawn_count
FROM gameobject go
JOIN gameobject_template got ON go.id = got.entry
WHERE go.map = 0
  AND go.position_x BETWEEN -14500 AND -11500
  AND go.position_y BETWEEN -1100 AND 1300
GROUP BY got.entry, got.name, got.type
ORDER BY spawn_count DESC
LIMIT 30;

-- Top Results:
-- Gold Vein (116), Silver Vein (94), Goldthorn (93), Iron Deposit (86)
-- Giant Clam (80), Kingsblood (78), Khadgar's Whisker (77)

-- RESOURCE NODES ANALYSIS
-- Type 3 = Resource/Container (ore, herbs, chests, quest items)
SELECT 
    got.entry,
    got.name,
    got.type,
    COUNT(*) as spawn_count
FROM gameobject go
JOIN gameobject_template got ON go.id = got.entry
WHERE go.map = 0
  AND go.position_x BETWEEN -14500 AND -11500
  AND go.position_y BETWEEN -1100 AND 1300
  AND got.type = 3
GROUP BY got.entry, got.name, got.type
ORDER BY spawn_count DESC;

-- Total Type 3 objects: 994 (50% of all gameobjects)

-- Mining Nodes: 434 total
-- - Gold Vein: 116
-- - Silver Vein: 94
-- - Iron Deposit: 86
-- - Mithril Deposit: 30
-- - Truesilver Deposit: 30
-- - Tin Vein: 8

-- Herbalism Nodes: 560 total
-- - Goldthorn: 93
-- - Kingsblood: 78
-- - Khadgar's Whisker: 77
-- - Liferoot: 68
-- - Stranglekelp: 67 (underwater)
-- - Wild Steelbloom: 52
-- - Fadeleaf: 28
-- - Purple Lotus: 27 (rare, high-tier)

-- Special Resources:
-- - Giant Clam: 80 (underwater gathering)

-- Chests:
-- - Solid Chest (various entries): 28 total

-- Quest Objects (single spawns):
-- - Fall of Gurubashi, The Emperor's Tomb, Moon Over the Vale (books)
-- - Kurzen Supplies, Cozzle's Footlocker (containers)
-- - Trophy Skulls (quest objectives)
-- - The Holy Spring (landmark)

-- Event Objects: 132 total (temporary seasonal content)
-- - Festive Mug: 70
-- - Toasting Goblet: 62

-- ============================================================================
-- ARCHITECTURAL FINDINGS
-- ============================================================================

-- 1. RESOURCE-RICH ZONE DESIGN
-- STV has nearly 1:1 ratio of gameobjects to creatures (1,979 vs 1,572)
-- 50% of all gameobjects are resource nodes (994 of 1,979)
-- Zone prioritizes gathering gameplay (mining, herbalism, fishing)

-- 2. TIERED RESOURCE DISTRIBUTION
-- Mining focuses on mid-to-high tier:
--   - Low-tier scarce: 8 tin veins (1.8%)
--   - Mid-tier abundant: 296 gold/silver/iron (68%)
--   - High-tier present: 60 mithril/truesilver (14%)
-- 
-- Herbalism spans wide range:
--   - Mid-tier dominant: 338 goldthorn/kingsblood/khadgar/liferoot (60%)
--   - High-tier available: 27 purple lotus (5%)
--
-- Pattern: Resource spawn count inversely correlates with tier/rarity

-- 3. MULTI-ENVIRONMENT DESIGN
-- Land: Standard ore and herb nodes
-- Underwater: Stranglekelp (67), Giant Clam (80)
-- Coastal: Fishing pools (126 total)
--   - School of Tastyfish: 46
--   - Greater Sagefish School: 25
--   - Firefin Snapper Schools: 38
--   - Waterlogged Wreckage: 17

-- 4. EVENT OVERLAY SYSTEM
-- 132 event objects (6.7% of total) overlay on permanent content
-- Brewfest, Midsummer Fire Festival, Halloween decorations
-- Events augment rather than replace base content
-- Architectural pattern: Layered content system

-- 5. PHYSICAL QUEST OBJECT DESIGN
-- Quests use 3D world objects, not just NPCs:
--   - Books to read (lore objects)
--   - Containers to loot (supplies, footlockers)
--   - Landmarks to discover (The Holy Spring)
--   - Trophies to collect (skulls)
-- Encourages spatial exploration and world immersion

-- 6. GAMEOBJECT TEMPLATE RELATIONSHIP
-- gameobject.id → gameobject_template.entry (type system)
-- Similar to creature → creature_template pattern
-- One template can have many spawn instances
-- Example: "Gold Vein" (entry 1734) has 116 spawn instances

-- ============================================================================
-- IMPLICATIONS FOR PORT GURUBASHI
-- ============================================================================

-- Resource Considerations:
-- - Custom resources could create unique gathering gameplay
-- - Consider neutral territory gathering rules (PvP-safe nodes?)
-- - Victory Coin economy might integrate with resource trading

-- Environmental Design:
-- - Arena conversion = land-based (no underwater components)
-- - Consider adding fishing access if near water
-- - Resource spawns should match zone level (30-45 tier)

-- Quest Object Patterns:
-- - Physical objects for custom quest chains (trophies, markers)
-- - Event decoration support for custom celebrations
-- - Chest/container integration for rewards

-- ============================================================================