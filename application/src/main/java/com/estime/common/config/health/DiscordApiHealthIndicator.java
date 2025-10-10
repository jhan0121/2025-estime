package com.estime.common.config.health;

import lombok.RequiredArgsConstructor;
import net.dv8tion.jda.api.JDA;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DiscordApiHealthIndicator implements HealthIndicator {

    private static final long GATEWAY_PING_WARNING_THRESHOLD = 1000L;
    private static final long GATEWAY_PING_DOWN_THRESHOLD = 5000L;

    private final JDA jda;

    @Override
    public Health health() {
        try {
            final JDA.Status status = jda.getStatus();
            final long gatewayPing = jda.getGatewayPing();

            if (status != JDA.Status.CONNECTED) {
                return Health.down()
                        .withDetail("status", status.name())
                        .withDetail("gatewayPing", gatewayPing + "ms")
                        .withDetail("reason", "JDA is not connected")
                        .build();
            }

            if (gatewayPing > GATEWAY_PING_DOWN_THRESHOLD) {
                return Health.down()
                        .withDetail("status", status.name())
                        .withDetail("gatewayPing", gatewayPing + "ms")
                        .withDetail("reason", "Gateway ping too high")
                        .build();
            }

            if (gatewayPing > GATEWAY_PING_WARNING_THRESHOLD) {
                return Health.up()
                        .withDetail("status", status.name())
                        .withDetail("gatewayPing", gatewayPing + "ms")
                        .withDetail("warning", "Gateway ping is high")
                        .build();
            }

            return Health.up()
                    .withDetail("status", status.name())
                    .withDetail("gatewayPing", gatewayPing + "ms")
                    .build();
        } catch (final Exception e) {
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .withException(e)
                    .build();
        }
    }
}
