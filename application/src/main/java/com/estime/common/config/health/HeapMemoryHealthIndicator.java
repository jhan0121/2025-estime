package com.estime.common.config.health;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
public class HeapMemoryHealthIndicator implements HealthIndicator {

    private static final double THRESHOLD = 0.85; // 85%

    @Override
    public Health health() {
        try {
            MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
            MemoryUsage heapUsage = memoryBean.getHeapMemoryUsage();

            long used = heapUsage.getUsed();
            long max = heapUsage.getMax();
            double usage = (double) used / max;

            if (usage > THRESHOLD) {
                return Health.down()
                        .withDetail("usage", String.format("%.2f%%", usage * 100))
                        .withDetail("used", formatBytes(used))
                        .withDetail("max", formatBytes(max))
                        .withDetail("threshold", String.format("%.0f%%", THRESHOLD * 100))
                        .withDetail("reason", "Heap memory usage exceeded threshold")
                        .build();
            }

            return Health.up()
                    .withDetail("usage", String.format("%.2f%%", usage * 100))
                    .withDetail("used", formatBytes(used))
                    .withDetail("max", formatBytes(max))
                    .build();

        } catch (Exception e) {
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .build();
        }
    }

    private String formatBytes(long bytes) {
        return String.format("%.2f MB", bytes / 1024.0 / 1024.0);
    }
}
