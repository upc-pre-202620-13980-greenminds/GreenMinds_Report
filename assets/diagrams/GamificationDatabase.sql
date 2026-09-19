-- EcoMind: Gamification. Proposed MySQL 8 schema; UUIDs match the domain model.
-- External IDs intentionally have no cross-context foreign keys.
CREATE TABLE user_progress (
 id CHAR(36) NOT NULL PRIMARY KEY,
 user_id CHAR(36) NOT NULL COMMENT 'Users reference',
 total_ecopoints BIGINT NOT NULL DEFAULT 0,
 total_experience BIGINT NOT NULL DEFAULT 0,
 current_streak INT NOT NULL DEFAULT 0,
 longest_streak INT NOT NULL DEFAULT 0,
 last_activity_date DATE NULL,
 last_protected_date DATE NULL,
 version BIGINT NOT NULL DEFAULT 0,
 updated_at DATETIME(6) NOT NULL,
 CONSTRAINT uq_user_progress UNIQUE (user_id),
 CONSTRAINT ck_progress_nonnegative CHECK (total_ecopoints >= 0 AND total_experience >= 0 AND current_streak >= 0 AND longest_streak >= current_streak)
);
CREATE TABLE family_scores (
 id CHAR(36) NOT NULL PRIMARY KEY,
 family_id CHAR(36) NOT NULL COMMENT 'Users reference',
 total_ecopoints BIGINT NOT NULL DEFAULT 0,
 version BIGINT NOT NULL DEFAULT 0,
 updated_at DATETIME(6) NOT NULL,
 CONSTRAINT uq_family_score UNIQUE (family_id),
 CONSTRAINT ck_family_nonnegative CHECK (total_ecopoints >= 0)
);
CREATE TABLE reward_transactions (
 id CHAR(36) NOT NULL PRIMARY KEY,
 source_type VARCHAR(24) NOT NULL,
 source_execution_id CHAR(36) NOT NULL COMMENT 'Canonical execution reference',
 beneficiary_type VARCHAR(8) NOT NULL,
 beneficiary_id CHAR(36) NOT NULL COMMENT 'Users user or family reference',
 user_progress_id CHAR(36) NULL,
 family_score_id CHAR(36) NULL,
 base_ecopoints BIGINT NOT NULL,
 base_experience BIGINT NOT NULL,
 base_gems INT NOT NULL,
 ecopoints BIGINT NOT NULL,
 experience BIGINT NOT NULL,
 gems INT NOT NULL,
 multiplier_id CHAR(36) NULL COMMENT 'Monetization reference',
 applied_factor DECIMAL(8,4) NOT NULL DEFAULT 1,
 granted_at DATETIME(6) NOT NULL,
 CONSTRAINT uq_reward_origin UNIQUE (source_type, source_execution_id, beneficiary_type, beneficiary_id),
 CONSTRAINT fk_reward_user FOREIGN KEY (user_progress_id) REFERENCES user_progress(id),
 CONSTRAINT fk_reward_family FOREIGN KEY (family_score_id) REFERENCES family_scores(id),
 CONSTRAINT ck_reward_target CHECK ((beneficiary_type='USER' AND user_progress_id IS NOT NULL AND family_score_id IS NULL) OR (beneficiary_type='FAMILY' AND family_score_id IS NOT NULL AND user_progress_id IS NULL)),
 CONSTRAINT ck_reward_amounts CHECK (base_ecopoints >= 0 AND base_experience >= 0 AND base_gems >= 0 AND ecopoints >= 0 AND experience >= 0 AND gems >= 0 AND applied_factor >= 1),
 CONSTRAINT ck_family_reward CHECK (beneficiary_type <> 'FAMILY' OR (experience=0 AND gems=0)),
 CONSTRAINT ck_source_type CHECK (source_type IN ('QUEST','MINIGAME','COLLABORATIVE_QUEST','FAMILY_PLAN','COMMUNITY_GOAL','COMMUNITY_EVENT')),
 INDEX ix_reward_period (beneficiary_type, beneficiary_id, granted_at)
);
CREATE TABLE achievements (
 id CHAR(36) NOT NULL PRIMARY KEY,
 code VARCHAR(80) NOT NULL,
 name VARCHAR(120) NOT NULL,
 description VARCHAR(500) NOT NULL,
 scope VARCHAR(16) NOT NULL,
 criterion_type VARCHAR(80) NOT NULL,
 criterion_target BIGINT NOT NULL,
 cosmetic_id CHAR(36) NULL COMMENT 'Monetization reference',
 active BOOLEAN NOT NULL DEFAULT TRUE,
 CONSTRAINT uq_achievement_code UNIQUE (code),
 CONSTRAINT ck_achievement_scope CHECK (scope IN ('INDIVIDUAL','FAMILY','COMMUNITY')),
 CONSTRAINT ck_achievement_target CHECK (criterion_target > 0),
 CONSTRAINT ck_cosmetic_scope CHECK (cosmetic_id IS NULL OR scope='INDIVIDUAL')
);
CREATE TABLE achievement_awards (
 id CHAR(36) NOT NULL PRIMARY KEY,
 achievement_id CHAR(36) NOT NULL,
 user_progress_id CHAR(36) NULL,
 family_score_id CHAR(36) NULL,
 community_id CHAR(36) NULL COMMENT 'Community reference',
 source_event_id CHAR(36) NOT NULL,
 awarded_at DATETIME(6) NOT NULL,
 CONSTRAINT fk_award_achievement FOREIGN KEY (achievement_id) REFERENCES achievements(id),
 CONSTRAINT fk_award_user FOREIGN KEY (user_progress_id) REFERENCES user_progress(id),
 CONSTRAINT fk_award_family FOREIGN KEY (family_score_id) REFERENCES family_scores(id),
 CONSTRAINT uq_award_user UNIQUE (achievement_id, user_progress_id),
 CONSTRAINT uq_award_family UNIQUE (achievement_id, family_score_id),
 CONSTRAINT uq_award_community UNIQUE (achievement_id, community_id),
 CONSTRAINT ck_award_target CHECK ((user_progress_id IS NOT NULL) + (family_score_id IS NOT NULL) + (community_id IS NOT NULL) = 1)
);
CREATE TABLE achievement_share_requests (
 id CHAR(36) NOT NULL PRIMARY KEY COMMENT 'Stable requestId across retries',
 award_id CHAR(36) NOT NULL,
 requested_by CHAR(36) NOT NULL COMMENT 'Authenticated Users reference',
 community_id CHAR(36) NOT NULL COMMENT 'Community reference',
 status VARCHAR(16) NOT NULL DEFAULT 'PENDING',
 publication_id CHAR(36) NULL COMMENT 'Community post reference',
 requested_at DATETIME(6) NOT NULL,
 confirmed_at DATETIME(6) NULL,
 version BIGINT NOT NULL DEFAULT 0,
 CONSTRAINT fk_share_award FOREIGN KEY (award_id) REFERENCES achievement_awards(id),
 CONSTRAINT uq_share_publication UNIQUE (publication_id),
 CONSTRAINT ck_share_status CHECK (status IN ('PENDING','PUBLISHED')),
 CONSTRAINT ck_share_confirmation CHECK ((status='PENDING' AND publication_id IS NULL AND confirmed_at IS NULL) OR (status='PUBLISHED' AND publication_id IS NOT NULL AND confirmed_at IS NOT NULL)),
 CONSTRAINT ck_share_dates CHECK (confirmed_at IS NULL OR confirmed_at >= requested_at),
 INDEX ix_share_requester (requested_by, requested_at)
);
CREATE TABLE streak_protection_requests (
 id CHAR(36) NOT NULL PRIMARY KEY,
 user_progress_id CHAR(36) NOT NULL,
 streak_date DATE NOT NULL,
 status VARCHAR(16) NOT NULL DEFAULT 'PENDING',
 created_at DATETIME(6) NOT NULL,
 resolved_at DATETIME(6) NULL,
 CONSTRAINT fk_protection_progress FOREIGN KEY (user_progress_id) REFERENCES user_progress(id),
 CONSTRAINT uq_protection_day UNIQUE (user_progress_id, streak_date),
 CONSTRAINT ck_protection_status CHECK (status IN ('PENDING','PROTECTED','UNAVAILABLE')),
 CONSTRAINT ck_protection_resolution CHECK ((status='PENDING' AND resolved_at IS NULL) OR (status<>'PENDING' AND resolved_at IS NOT NULL))
);
-- Infrastructure only: event_id and deduplication_key stay stable across retries.
CREATE TABLE gamification_outbox (
 id CHAR(36) NOT NULL PRIMARY KEY,
 event_type VARCHAR(100) NOT NULL,
 destination VARCHAR(40) NOT NULL,
 deduplication_key VARCHAR(180) NOT NULL,
 payload JSON NOT NULL,
 occurred_at DATETIME(6) NOT NULL,
 published_at DATETIME(6) NULL,
 attempt_count INT NOT NULL DEFAULT 0,
 CONSTRAINT uq_outbox_delivery UNIQUE (destination, deduplication_key),
 CONSTRAINT ck_outbox_attempt CHECK (attempt_count >= 0),
 INDEX ix_outbox_pending (published_at, occurred_at)
);
