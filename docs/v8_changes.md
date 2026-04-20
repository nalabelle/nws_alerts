# WX Watcher v8 Changes

## Entity-Based Locations

Locations are now defined by Home Assistant entities instead of free-text names:

- **Static locations** are HA zone entities (e.g., `zone.home`, `zone.work`)
- **Tracked locations** are device tracker entities (e.g., `device_tracker.phone`)

The free-text `name` field has been removed. Friendly names are derived from
entity state at display time.

## Event Source Data

Event `sources` now use entity IDs:

- Static: `{"ha_zone": "zone.home", "mode": "zone"}`
- Tracked: `{"tracker": "device_tracker.phone", "mode": "point"}`

The `location` key has been removed.

## Tracker Skip Optimization

When a tracked device's state indicates it is inside a static location's HA zone
(e.g., device_tracker state is `"home"` when `zone.home` is a static location),
the coordinator skips the tracked device's NWS API query entirely. The static
location's zone query is a superset — it already covers the area.

This means:

- When phone is at home: only the home zone query runs. Events carry
  `ha_zone: zone.home` in sources, never both `ha_zone` and `tracker`.
- When phone is away: both queries run. Home events carry `ha_zone`,
  phone events carry `tracker`. These are different alerts (different IDs)
  for different geographic areas.

## Config Flow Changes

- Removed manual GPS and manual NWS zone ID source options
- All static locations start from an HA zone entity
- NWS zone IDs are auto-resolved but editable via the form
- Zone IDs are deduplicated on save
- Added edit and remove location flows
- Device trackers use entity selector instead of raw dropdown
- Location names are no longer configurable (derived from entity friendly name)

## Blueprint

See `blueprints/automation/wx_watcher_ticker.yaml` — routes alert notifications
per-user based on static locations and tracked devices. Supports multiple zones
and multiple devices per automation instance.
