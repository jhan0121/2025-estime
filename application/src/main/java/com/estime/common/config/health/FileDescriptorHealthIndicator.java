package com.estime.common.config.health;

import com.sun.management.UnixOperatingSystemMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.OperatingSystemMXBean;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
public class FileDescriptorHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        try {
            OperatingSystemMXBean os = ManagementFactory.getOperatingSystemMXBean();

            if (os instanceof UnixOperatingSystemMXBean unixOs) {
                long openFd = unixOs.getOpenFileDescriptorCount();
                long maxFd = unixOs.getMaxFileDescriptorCount();
                double usage = (double) openFd / maxFd * 100;

                if (usage > 80) {
                    return Health.down()
                            .withDetail("openFileDescriptors", openFd)
                            .withDetail("maxFileDescriptors", maxFd)
                            .withDetail("usage", String.format("%.2f%%", usage))
                            .build();
                }

                return Health.up()
                        .withDetail("openFileDescriptors", openFd)
                        .withDetail("maxFileDescriptors", maxFd)
                        .withDetail("usage", String.format("%.2f%%", usage))
                        .build();
            }

            return Health.unknown().withDetail("os", "Not Unix-based").build();
        } catch (Exception e) {
            return Health.down().withException(e).build();
        }
    }
}
