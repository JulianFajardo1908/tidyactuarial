# Sample cash flows for interest theory examples

A small pedagogical dataset containing cash-flow scenarios for present
value, future value, net present value, internal rate of return,
equations of value, and cash-flow diagrams.

A small pedagogical dataset containing cash-flow scenarios for present
value, future value, net present value, internal rate of return,
equations of value, and cash-flow diagrams.

## Usage

``` r
cash_flows_sample

cash_flows_sample
```

## Format

A tibble with 19 rows and 5 variables:

- scenario_id:

  Scenario identifier.

- t:

  Payment time.

- C:

  Cash-flow amount. Negative values represent outflows and positive
  values represent inflows.

- cashflow_type:

  Type of cash flow.

- description:

  Short description of the cash flow.

A tibble with 19 rows and 5 variables:

- scenario_id:

  Scenario identifier.

- t:

  Payment time.

- C:

  Cash-flow amount. Negative values represent outflows and positive
  values represent inflows.

- cashflow_type:

  Type of cash flow.

- description:

  Short description of the cash flow.

## Source

Synthetic pedagogical data created for tidyactuarial examples.

Synthetic pedagogical data created for tidyactuarial examples.

## Details

This dataset uses the compact financial-actuarial notation used
throughout `tidyactuarial`: `t` denotes time and `C` denotes the
cash-flow amount at that time.

This dataset uses the compact financial-actuarial notation used
throughout `tidyactuarial`: `t` denotes time and `C` denotes the
cash-flow amount at that time.

## Examples

``` r
data(cash_flows_sample)

cash_flows_sample |>
  dplyr::filter(scenario_id == "investment_project") |>
  dplyr::select(scenario_id, t, C, cashflow_type)
#> # A tibble: 6 × 4
#>   scenario_id            t      C cashflow_type     
#>   <chr>              <dbl>  <dbl> <chr>             
#> 1 investment_project     0 -10000 initial_investment
#> 2 investment_project     1   2500 inflow            
#> 3 investment_project     2   2800 inflow            
#> 4 investment_project     3   3200 inflow            
#> 5 investment_project     4   3500 inflow            
#> 6 investment_project     5   4000 inflow            

data(cash_flows_sample)

cash_flows_sample |>
  dplyr::filter(scenario_id == "investment_project") |>
  dplyr::select(scenario_id, t, C, cashflow_type)
#> # A tibble: 6 × 4
#>   scenario_id            t      C cashflow_type     
#>   <chr>              <dbl>  <dbl> <chr>             
#> 1 investment_project     0 -10000 initial_investment
#> 2 investment_project     1   2500 inflow            
#> 3 investment_project     2   2800 inflow            
#> 4 investment_project     3   3200 inflow            
#> 5 investment_project     4   3500 inflow            
#> 6 investment_project     5   4000 inflow            
```
