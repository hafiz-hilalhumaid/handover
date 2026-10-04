-- 001: the three core tables. Runs once, ever. Never edit it after it has run;
-- any later change goes in a new numbered file.

CREATE TABLE projects (
    id          bigserial    PRIMARY KEY,
    name        text         NOT NULL,
    developer   text         NOT NULL,
    location    text         NOT NULL,
    created_at  timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE units (
    id           bigserial    PRIMARY KEY,
    project_id   bigint       NOT NULL REFERENCES projects(id),
    unit_number  text         NOT NULL,
    floor        integer,
    created_at   timestamptz  NOT NULL DEFAULT now(),
    UNIQUE (project_id, unit_number),
    -- Needed so handover_items can point at the pair, not just the id.
    UNIQUE (id, project_id)
);

CREATE TABLE handover_items (
    id           bigserial    PRIMARY KEY,
    project_id   bigint       NOT NULL REFERENCES projects(id),
    unit_id      bigint,
    location     text         NOT NULL,
    description  text         NOT NULL,
    trade        text         NOT NULL,
    severity     text         NOT NULL
                 CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    status       text         NOT NULL DEFAULT 'open'
                 CHECK (status IN ('open', 'in_progress', 'fixed', 'verified', 'closed', 'rejected')),
    raised_at    timestamptz  NOT NULL DEFAULT now(),
    resolved_at  timestamptz,
    CHECK (resolved_at IS NULL OR resolved_at >= raised_at),
    -- The unit must exist AND belong to the same project as the defect.
    -- unit_id stays NULL for common-area defects (MATCH SIMPLE skips the check).
    CONSTRAINT handover_items_unit_in_same_project
        FOREIGN KEY (unit_id, project_id) REFERENCES units (id, project_id)
);