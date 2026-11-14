-- EcoMind: Gamification. PostgreSQL persistence mappings.

CREATE TABLE family_scores (
 family_id BIGINT NOT NULL PRIMARY KEY,
 total_ecopoints BIGINT NOT NULL,
 version BIGINT NOT NULL,
 CHECK (total_ecopoints >= 0)
);

CREATE TABLE achievements (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 code VARCHAR(80) NOT NULL UNIQUE,
 name VARCHAR(120) NOT NULL,
 description VARCHAR(500) NOT NULL,
 scope VARCHAR(16) NOT NULL,
 metric VARCHAR(40) NOT NULL,
 target BIGINT NOT NULL,
 active BOOLEAN NOT NULL,
 cosmetic_id VARCHAR(36),
 CHECK (target > 0 AND scope IN ('INDIVIDUAL','FAMILY','COMMUNITY') AND (cosmetic_id IS NULL OR scope = 'INDIVIDUAL'))
);

CREATE TABLE gamification_minigame_completions (
 execution_id VARCHAR(36) NOT NULL PRIMARY KEY,
 user_id BIGINT NOT NULL,
 minigame_id VARCHAR(36) NOT NULL,
 occurred_at TIMESTAMP(6) WITH TIME ZONE NOT NULL
);

CREATE TABLE gamification_outbox (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 message_type VARCHAR(40) NOT NULL,
 correlation_id VARCHAR(36) NOT NULL,
 user_id BIGINT,
 achievement_id VARCHAR(36),
 award_id VARCHAR(36),
 community_id VARCHAR(36),
 cosmetic_id VARCHAR(36),
 gems INTEGER NOT NULL,
 streak_date DATE,
 occurred_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 next_attempt_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 delivered_at TIMESTAMP(6) WITH TIME ZONE,
 attempts INTEGER NOT NULL,
 version BIGINT NOT NULL,
 UNIQUE (message_type, correlation_id)
);

CREATE TABLE achievement_milestones (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 metric VARCHAR(40) NOT NULL,
 beneficiary VARCHAR(48) NOT NULL,
 execution_id VARCHAR(36) NOT NULL,
 UNIQUE (metric, beneficiary, execution_id)
);

CREATE TABLE reward_transactions (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 source_type VARCHAR(24) NOT NULL,
 source_execution_id VARCHAR(36) NOT NULL,
 beneficiary_type VARCHAR(8) NOT NULL,
 beneficiary_id BIGINT NOT NULL,
 base_ecopoints BIGINT NOT NULL,
 base_gems INTEGER NOT NULL,
 ecopoints BIGINT NOT NULL,
 gems INTEGER NOT NULL,
 multiplier_id VARCHAR(36),
 applied_factor NUMERIC(18,8) NOT NULL,
 repetition_factor NUMERIC(18,8) NOT NULL,
 occurred_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 user_progress_id BIGINT,
 family_score_id BIGINT,
 UNIQUE (source_type, source_execution_id, beneficiary_type, beneficiary_id),
 CHECK (base_ecopoints >= 0 AND base_gems >= 0 AND ecopoints >= 0 AND gems >= 0 AND applied_factor >= 0 AND repetition_factor BETWEEN 0 AND 1 AND source_type IN ('QUEST','MINIGAME','COLLABORATIVE_QUEST','FAMILY_PLAN','COMMUNITY_GOAL','COMMUNITY_EVENT','STREAK_BONUS') AND ((beneficiary_type = 'USER' AND user_progress_id IS NOT NULL AND user_progress_id = beneficiary_id AND family_score_id IS NULL) OR (beneficiary_type = 'FAMILY' AND family_score_id IS NOT NULL AND family_score_id = beneficiary_id AND user_progress_id IS NULL AND base_gems = 0 AND gems = 0)))
);

CREATE TABLE user_progresses (
 user_id BIGINT NOT NULL PRIMARY KEY,
 total_ecopoints BIGINT NOT NULL,
 current_streak INTEGER NOT NULL,
 longest_streak INTEGER NOT NULL,
 last_activity_date DATE,
 last_protected_date DATE,
 version BIGINT NOT NULL,
 CHECK (total_ecopoints >= 0 AND current_streak >= 0 AND longest_streak >= current_streak)
);

CREATE TABLE achievement_milestone_locks (
 beneficiary VARCHAR(48) NOT NULL PRIMARY KEY
);

CREATE TABLE streak_protection_requests (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 user_id BIGINT NOT NULL,
 streak_date DATE NOT NULL,
 status VARCHAR(16) NOT NULL,
 created_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 resolved_at TIMESTAMP(6) WITH TIME ZONE,
 version BIGINT NOT NULL,
 UNIQUE (user_id, streak_date),
 CHECK ((status = 'PENDING' AND resolved_at IS NULL) OR (status IN ('PROTECTED','UNAVAILABLE') AND resolved_at IS NOT NULL AND resolved_at >= created_at))
);

CREATE TABLE achievement_share_requests (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 award_id VARCHAR(36) NOT NULL,
 requested_by BIGINT NOT NULL,
 community_id VARCHAR(36) NOT NULL,
 publication_id VARCHAR(36),
 status VARCHAR(16) NOT NULL,
 created_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 confirmed_at TIMESTAMP(6) WITH TIME ZONE,
 version BIGINT NOT NULL,
 UNIQUE (publication_id),
 CHECK (requested_by > 0 AND ((status = 'PENDING' AND publication_id IS NULL AND confirmed_at IS NULL) OR (status = 'PUBLISHED' AND publication_id IS NOT NULL AND confirmed_at IS NOT NULL AND confirmed_at >= created_at)))
);

CREATE TABLE achievement_awards (
 id VARCHAR(36) NOT NULL PRIMARY KEY,
 achievement_id VARCHAR(36) NOT NULL,
 scope VARCHAR(16) NOT NULL,
 beneficiary_id BIGINT,
 community_id VARCHAR(36),
 source_event_id VARCHAR(36) NOT NULL,
 awarded_at TIMESTAMP(6) WITH TIME ZONE NOT NULL,
 user_progress_id BIGINT,
 family_score_id BIGINT,
 UNIQUE (achievement_id, scope, beneficiary_id),
 UNIQUE (achievement_id, community_id)
);

ALTER TABLE reward_transactions ADD FOREIGN KEY (user_progress_id) REFERENCES user_progresses (user_id);

ALTER TABLE reward_transactions ADD FOREIGN KEY (family_score_id) REFERENCES family_scores (family_id);

ALTER TABLE streak_protection_requests ADD FOREIGN KEY (user_id) REFERENCES user_progresses (user_id);

ALTER TABLE achievement_share_requests ADD FOREIGN KEY (award_id) REFERENCES achievement_awards (id);

ALTER TABLE achievement_awards ADD FOREIGN KEY (achievement_id) REFERENCES achievements (id);

ALTER TABLE achievement_awards ADD FOREIGN KEY (user_progress_id) REFERENCES user_progresses (user_id);

ALTER TABLE achievement_awards ADD FOREIGN KEY (family_score_id) REFERENCES family_scores (family_id);
