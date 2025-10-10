package com.estime.common.config.health;

import java.time.Duration;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class DatabaseResponseTimeHealthIndicator implements HealthIndicator {

    private final JdbcTemplate jdbcTemplate;

    private static final Duration WARNING_THRESHOLD = Duration.ofSeconds(1);
    private static final Duration CRITICAL_THRESHOLD = Duration.ofSeconds(5);

    @Override
    public Health health() {
        final long start = System.currentTimeMillis();

        try {
            jdbcTemplate.queryForList(
                    "SELECT 1 FROM room LIMIT 1",
                    Integer.class
            );

            final Duration duration = Duration.ofMillis(System.currentTimeMillis() - start);

            log.debug("Database health check query='SELECT 1 FROM room LIMIT 1' took {}ms", duration.toMillis());

            if (duration.compareTo(CRITICAL_THRESHOLD) > 0) {
                return Health.down()
                        .withDetail("responseTime", duration.toMillis() + "ms")
                        .withDetail("threshold", CRITICAL_THRESHOLD.toMillis() + "ms")
                        .withDetail("severity", "critical")
                        .build();
            }

            if (duration.compareTo(WARNING_THRESHOLD) > 0) {
                return Health.up()
                        .withDetail("responseTime", duration.toMillis() + "ms")
                        .withDetail("severity", "warning")
                        .build();
            }

            return Health.up()
                    .withDetail("responseTime", duration.toMillis() + "ms")
                    .build();

        } catch (Exception e) {
            log.error("Database health check failed", e);
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .withDetail("errorType", e.getClass().getSimpleName())
                    .build();
        }
    }
}
