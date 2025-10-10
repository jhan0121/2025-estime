package com.estime.common.config.health;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@ConditionalOnProperty(name = "deployment.test.enabled", havingValue = "true")
public class DeploymentTestHealthIndicator implements HealthIndicator {

    @Value("${deployment.test.fail:false}")
    private boolean shouldFail;

    @Override
    public Health health() {
        if (shouldFail) {
            log.warn("Deployment test health check is configured to fail");
            return Health.down()
                    .withDetail("reason", "Simulated deployment failure for testing")
                    .withDetail("test", true)
                    .build();
        }

        return Health.up()
                .withDetail("test", true)
                .build();
    }
}
