package com.estime.common.config.health;

import com.zaxxer.hikari.HikariDataSource;
import com.zaxxer.hikari.HikariPoolMXBean;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;

@Component
@RequiredArgsConstructor
public class HikariCPHealthIndicator implements HealthIndicator {

    private final DataSource dataSource;

    private static final double THRESHOLD = 0.8; // 80%

    @Override
    public Health health() {
        try {
            if (!(dataSource instanceof HikariDataSource)) {
                return Health.unknown()
                        .withDetail("reason", "DataSource is not HikariCP")
                        .withDetail("type", dataSource.getClass().getSimpleName())
                        .build();
            }

            HikariDataSource hikariDataSource = (HikariDataSource) dataSource;
            HikariPoolMXBean poolBean = hikariDataSource.getHikariPoolMXBean();

            int active = poolBean.getActiveConnections();
            int total = poolBean.getTotalConnections();
            int idle = poolBean.getIdleConnections();
            int waiting = poolBean.getThreadsAwaitingConnection();

            double usage = total > 0 ? (double) active / total : 0;

            if (usage > THRESHOLD) {
                return Health.down()
                        .withDetail("usage", String.format("%.2f%%", usage * 100))
                        .withDetail("active", active)
                        .withDetail("total", total)
                        .withDetail("idle", idle)
                        .withDetail("waiting", waiting)
                        .withDetail("threshold", String.format("%.0f%%", THRESHOLD * 100))
                        .withDetail("reason", "Connection pool usage exceeded threshold")
                        .build();
            }

            return Health.up()
                    .withDetail("active", active)
                    .withDetail("total", total)
                    .withDetail("idle", idle)
                    .withDetail("waiting", waiting)
                    .withDetail("usage", String.format("%.2f%%", usage * 100))
                    .build();

        } catch (Exception e) {
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .withDetail("errorType", e.getClass().getSimpleName())
                    .build();
        }
    }
}
