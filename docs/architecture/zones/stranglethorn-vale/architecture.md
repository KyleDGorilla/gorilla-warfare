# StrangleThorn Vale - Technical Architecture Documentation

**Status**: Data Layer Analysis - In Progress  
**Started**: January 26, 2026  
**Last Updated**: January 26, 2026

## Zone Definition

### Geographic Identification

**Map**: 0 (Eastern Kingdoms)  
**Zone ID**: N/A (see architectural constraint below)

**Coordinate Boundaries**:
- **X Range**: -14596.7 to -10301 (~4,300 units wide)
- **Y Range**: -4196.7 to 1599.5 (~5,800 units tall)
- **Z Range**: -99.29 to 122.43 (~221 units elevation range)

**Total Area**: Approximately 4,300 × 5,800 units

**Entity Count** (Initial Survey):
- **Creatures**: 4,160 spawns
- **Gameobjects**: TBD
- **Quests**: TBD

### Verification

Zone identity confirmed through creature sampling:
- Booty Bay NPCs ("Sea Wolf" MacKinley, pirates)
- Nesingwary's Expedition (Ajeck Rouack)
- Coastal wildlife (Adolescent Whelps)
- Level range 1-65 (appropriate for STV zones)

---

## Data Layer Analysis

### Critical Architectural Constraint Discovered

**Issue**: The `creature.zoneId` column is unpopulated in this AzerothCore installation.

**Evidence**:
```sql
-- All 29,448 creatures on Eastern Kingdoms have zoneId = 0
SELECT zoneId, COUNT(*) 
FROM creature 
WHERE map = 0 
GROUP BY zoneId;

-- Result: Single row with zoneId=0, count=29448
```

**Impact**:
- Cannot use zone ID for spatial queries
- Must use coordinate-based WHERE clauses for all zone-specific queries
- Requires maintaining coordinate range constants
- Complicates cross-zone analysis

**Mitigation Strategy**:
- Define zone boundaries as constants at top of query files
- Consider creating database views with coordinate filters
- Document coordinate ranges prominently in all spatial queries

**Implication for Custom Content**:
Port Gurubashi and other custom content must also be identified by coordinates rather than zone IDs.

---

### Database Tables Involved

#### Core Tables (Confirmed)
- `creature` - Individual creature spawn instances
- `creature_template` - Creature type definitions
- `gameobject` - TBD
- `gameobject_template` - TBD
- `quest_template` - TBD
- `smart_scripts` - TBD

#### DBC Tables (Status)
- `areatable_dbc` - **Unpopulated** in this installation
  - Table exists with proper schema
  - All `AreaName_Lang_enUS` values are NULL
  - Cannot be used for zone identification

---

### Entity Relationships Discovered
```
creature (spawn instances)
    ├── id1 → creature_template.entry (creature type definition)
    ├── map (0 = Eastern Kingdoms)
    ├── zoneId (unpopulated, always 0)
    ├── position_x, position_y, position_z (spatial coordinates)
    └── guid (unique spawn identifier)
```

---

## Work Completed

### Phase 1A: Zone Identification ✅
**Completed**: January 26, 2026

**Objective**: Identify StrangleThorn Vale boundaries and verify zone identity.

**Challenges Encountered**:
1. Expected `areatable_dbc` to contain zone definitions - table was unpopulated
2. Expected `creature.zoneId` to differentiate zones - column not used
3. Had to adapt to coordinate-based identification

**Solution**: Used known approximate coordinates for STV and verified through creature name sampling.

**Deliverables**:
- Zone boundary coordinates established
- Query file: `01-zone-identification.sql`
- Architectural constraint documented

---

## Next Steps

### Phase 1B: Creature Analysis (In Progress)
- Analyze creature distribution patterns
- Document creature_template relationships
- Identify spawn group usage
- Count creatures by type/level

### Phase 1C: Gameobject Analysis (Upcoming)
- Identify interactive objects in zone
- Analyze gameobject_template relationships
- Document resource nodes (herbs, ore, chests)

### Phase 1D: Quest Analysis (Upcoming)
- Identify quests in or related to STV
- Document quest chains and dependencies

---

## Queries Saved

- `01-zone-identification.sql` - Zone boundary discovery and verification

---

*This is a living document updated as analysis progresses.*
