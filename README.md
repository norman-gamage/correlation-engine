# correlation-engine

## Introduction

*Correlation-engine* is a web application/platform, which is capable of calculating and visualizing correlation between different time-series. Primary objective of this work is to build a platform which could,

1. Process different time-series data
2. Calculate correlation near real-time
3. Scalable both vertically and horizontally

Correlation-engine is primarily based on `Node.js`, and uses number of other technologies such as `PostgreSQL`, `D3.js` and `Socket.io`.

This technical preview demonstrates the basic usage case, where correlation between two (2) time-series data is calculated for different time intervals i.e. minute, hour and continuous (see example below).

## Example

**Top graph:** `X` and `Y` are two independent time-series, where values are varied to simulate following correlation trends,

    0    - 1000   Positive
    1000 - 2000   Negative
    2000 - 3000   Saw-tooth
    3000 - 7000   Sinusoidal

x-axis: Time (in seconds)  
y-axis: Value

**Bottom graph:** Correlation between `X` and `Y` for time intervals minute (orange), hour (green) and continuous (blue).

x-axis: Time (in seconds)  
y-axis: Correlation (1: perfect positive, -1: perfect negative, 0: no correlation)

![alt text](https://github.com/norman-gamage/correlation-engine/blob/develop/docs/img/example.png)

## Future Developments

1. Timestamps
2. Better management/deployment tools
3. Handling input data gaps
