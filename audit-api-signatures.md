# Matriz global de firmas públicas

B08-02: mc_multilife_status conserva firma/esquema y 60 resultados válidos
completos idénticos a 9a7b441. C17 autorizada exige el intervalo exacto de T;
tol conserva la comprobación entera de K. K_status grande retiene double.

B08-01: simulate_lifetime/simulate_lifetimes conservan firmas y esquemas;
78 resultados completos ordinarios concuerdan con c7a0d29 a 1e-12.
Precisión/dominio puntual y límites en audit-monte-carlo-review.md;
la revisión integral de B08 permanece abierta.

B07-06: seis firmas cotejadas con 4b0948e, sin cambios; 138 resultados
ordinarios completos concuerdan a 1e-12. Contratos, estados y límites
conciliados en audit-multilife-contingencies.md. Inventario vivo comprobado:
102 nombres (101 funciones más el alias A_xj), 974 apariciones de parámetros.

Extracción de las 102 entradas de NAMESPACE sobre la rama audit/0.2.0-precran.
Se conservan los nombres, orden y defaults reales de formals(). El alias A_xj
se identifica expresamente. Este inventario no modifica ninguna firma.

Las descripciones transcriben la documentación Rd: contienen el concepto,
dominio y unidades cuando están documentados. No se infieren unidades a partir
de una letra. Las lagunas se marcan; la validación semántica se hace por bloques.
La columna pipe describe la posición de entrada, no una prueba de ejecución.

## Comparación de firmas

| Bloque | Entrada | Firma real | Primera entrada / pipe estructural | Opciones de salida | Retorno documentado |
|---|---|---|---|---|---|
| B01 | `accumulation_factor` | `accumulation_factor(s = 0, t, i = NULL, i_type = "effective", m = 1, a = NULL, delta = NULL, subdivisions = 100L, rel.tol = 1e-08, tidy = FALSE)` | s primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of accumulation factors. If tidy = TRUE , a tibble containing the interval, model, relevant intermediate quantities, and accumulation factor. |
| B01 | `discount_factor` | `discount_factor(s = 0, t, i = NULL, i_type = "effective", m = 1, a = NULL, delta = NULL, subdivisions = 100L, rel.tol = 1e-08, tidy = FALSE)` | s primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of discount factors. If tidy = TRUE , a tibble containing the interval, interest model, relevant intermediate quantities, accumulation factor, and discount factor. |
| B01 | `discount_factor_spot` | `discount_factor_spot(t, i, i_type = "effective", m = 1L, tidy = FALSE)` | t primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of discount factors. If tidy = TRUE , a tibble with input values, standardized rates, and discount factors. |
| B01 | `interest_equivalents` | `interest_equivalents(i_type = c("effective", "nominal_interest", "nominal_discount", "force"), i, m = 1L)` | i_type primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with columns: family Rate or factor family: "effective" , "discount" , "discount_factor" , "force" , "nominal_interest" , or "nominal_discount" . notation Actuarial notation for the equivalent rate. m Conversion frequency used for nominal rates. description Human-readable description. value Equivalent rate value. |
| B01 | `standardize_interest` | `standardize_interest(i_type = "effective", i, m = 1, ...)` | i_type primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | Numeric vector of annual effective rates. Missing values are propagated. |
| B02 | `future_value` | `future_value(C, i, i_type = "effective", m = 1, t, tidy = FALSE)` | C primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of future values. If tidy = TRUE , a tibble with input values, equivalent rates, accumulation factors, and future values. |
| B02 | `fv_flow` | `fv_flow(cf, i, i_type = "effective", m = 1L, t = NULL, date = NULL, day_count = c("act/365", "act/360"), tol = 1e-10)` | cf primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | Numeric scalar: the future value of the cash flow accumulated to the latest cash-flow time. |
| B02 | `irr_flow` | `irr_flow(cf, t = NULL, date = NULL, m = 1L, interval = c(-0.99, 10), tol = 1e-10, maxiter = 1000, day_count = c("act/365", "act/360"))` | cf primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A one-row tibble with: irr Estimated IRR as an annual effective rate. i_effective_annual Same as irr , reported explicitly. j_nominal_interest Equivalent nominal annual interest rate convertible m times. delta Equivalent force of interest. npv Present value at the estimated IRR, close to zero. interval_left Left endpoint of the search interval. interval_right Right endpoint of the search interval. converged Logical flag indicating whether a root was found. n_iter Number of iterations used by uniroot . n_cashflows Length of cf . has_both_signs Whether the cash flow has at least one positive and one negative value. n_sign_changes Number of sign changes in the nonzero cash-flow sequence. If no sign change is present in the cash flow, or if the NPV does not change sign over interval , the function returns converged = FALSE and irr = NA_real_ . |
| B02 | `irr_flow_multi` | `irr_flow_multi(cf, t = NULL, date = NULL, m = 1L, search_interval = c(-0.99, 10), grid_points = 2000L, tol = 1e-10, maxiter = 1000L, day_count = c("act/365", "act/360"))` | cf primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with one row per detected IRR and columns: root_id Root index. irr Detected IRR as an annual effective rate. i_effective_annual Same as irr , reported explicitly. j_nominal_interest Equivalent nominal annual interest rate convertible m times. delta Equivalent force of interest. npv NPV evaluated at the detected root, approximately zero. interval_left Left endpoint of the local search bracket. interval_right Right endpoint of the local search bracket. n_cashflows Length of cf . has_both_signs Whether the cash flow has at least one positive and one negative value. n_sign_changes_cashflow Number of sign changes in the nonzero cash-flow sequence. If no roots are detected, the function returns a tibble with zero rows. |
| B02 | `plot_cash_flow` | `plot_cash_flow(.data = NULL, C, t = NULL, date = NULL, i = NULL, i_type = "effective", m = 1L, PV = NULL, payment = NULL, time = NULL, rate = NULL, pv = NULL, title = NULL, subtitle = NULL, x_label = NULL, amount_label = "Cash flow", financial = TRUE, normalize = FALSE, aggregate = TRUE, show_labels = TRUE, label_size = 3.5, arrow_size = 0.8, timeline_size = 0.7, label_digits = 2L, label_format = c("auto", "full", "compact"), currency = "", col_inflow = "#1B9E77", col_outflow = "#D95F02", date_labels = "%Y-%m-%d", day_count = c("act/365", "act/360"), ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A ggplot2 object. |
| B02 | `present_value` | `present_value(C, i, i_type = "effective", m = 1, t, tidy = FALSE)` | C primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of present values. If tidy = TRUE , a tibble with input values, equivalent rates, discount factors, and present values. |
| B02 | `pv_flow` | `pv_flow(cf, i, i_type = "effective", m = 1L, t = NULL, date = NULL, day_count = c("act/365", "act/360"))` | cf primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | Numeric scalar: the present value of the cash flow. |
| B02 | `solve_value` | `solve_value(fn, solve_for, target, args = list(), result = NULL, interval = NULL, start = NULL, derivative = NULL, method = c("auto", "uniroot", "newton"), multiple = c("error", "all", "first"), tol = 1e-10, maxiter = 1000L, scan_points = 401L, max_expand = 6L, output = c("value", "summary", "audit"), residual_tol = tol)` | fn primero; pipe posicional posible, revisar pertinencia | `output = c("value", "summary", "audit")` | Depending on `output`: `"value"`: numeric scalar or vector containing the solution(s). `"summary"`: compact tibble with the unknown, solution, target, achieved value, residual, and method. `"audit"`: detailed tibble with convergence diagnostics and search information. |
| B03 | `a_angle` | `a_angle(n = NULL, k = 1L, i, i_type = "effective", m = 1L, h = 0, timing = "immediate", perpetuity = FALSE, payment = 1, tidy = FALSE)` | n primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of annuity factors. If tidy = TRUE , a tibble with input values, equivalent rates, annuity factors, payment amounts, and present values. |
| B03 | `amort_schedule` | `amort_schedule(principal, n, i, i_type = "effective", m = 1L, k = 1L, timing = c("immediate", "due"), payment = NULL, extra_principal = NULL, adjust = c("none", "term", "payment"), tol = 1e-08)` | principal primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with one row per realized period and columns: period Period index. ob_start Outstanding balance at the start of the period. interest Interest charged during the period. payment Regular payment in the period. extra_principal Extra principal paid in the period. principal Principal repaid through the regular payment. total_principal Total principal repaid in the period. cashflow Total payment made in the period. ob_end Outstanding balance at the end of the period. i_effective_annual Equivalent annual effective rate. i_effective_period Equivalent effective rate per schedule period. k Schedule frequency. timing Payment timing convention. adjust Adjustment rule used. |
| B03 | `amort_schedule_general` | `amort_schedule_general(principal, n, i, i_type = "effective", m = 1L, k = 1L, timing = c("immediate", "due"), payment = NULL, extra_principal = 0, output = c("schedule", "summary"), tol = 1e-08)` | principal primero; pipe posicional posible, revisar pertinencia | `output = c("schedule", "summary")` | With output = "schedule" , a tibble with one row per realized period. With output = "summary" , a one-row tibble containing the initial principal, number of realized periods, total interest, total paid, ending balance, and an indicator of negative amortization. |
| B03 | `annuity_arith` | `annuity_arith(n, k = 1L, i, i_type = "effective", m = 1L, h = 0, timing = "immediate", pattern = "increasing", P1 = 1, g = 1, valuation = c("present", "accumulated"), tidy = FALSE)` | n primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of arithmetic annuity factors. If tidy = TRUE , a tibble with input values, equivalent rates, period quantities, and both present and accumulated value factors. |
| B03 | `annuity_geom` | `annuity_geom(n = NULL, k = 1L, i, i_type = "effective", m = 1L, g = 0, g_type = "effective", g_m = 1L, h = 0, timing = "immediate", P1 = 1, perpetuity = FALSE, valuation = c("present", "accumulated"), tidy = FALSE)` | n primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector. If tidy = TRUE , a tibble with input values, equivalent rates, period quantities, and both present and accumulated value factors. |
| B03 | `s_angle` | `s_angle(n, k = 1L, i, i_type = "effective", m = 1L, h = 0, timing = "immediate", payment = 1, tidy = FALSE)` | n primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of accumulation factors. If tidy = TRUE , a tibble with input values, equivalent rates, accumulation factors, payment amounts, and future values. |
| B03 | `sinking_fund_schedule` | `sinking_fund_schedule(principal, n, i, j, k = 1L, i_type = "effective", j_type = "effective", m = 1L, j_m = 1L, deposit = NULL, tol = 1e-08)` | principal primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with one row per period and columns: period Period index. loan_balance_start Outstanding loan balance at the start of the period. interest_loan Interest paid on the loan during the period. sinking_deposit Deposit made into the sinking fund. fund_balance_start Fund balance at the start of the period. interest_fund Interest earned by the fund during the period. fund_balance_end_before_redemption Fund balance before final redemption. redemption_from_fund Amount withdrawn from the fund to redeem the loan at maturity. fund_balance_end Fund balance after redemption. loan_balance_end Outstanding loan balance after redemption. total_cashflow_borrower Borrower's external cash outflow during the period. i_effective_loan_annual Equivalent annual effective loan rate. i_effective_fund_annual Equivalent annual effective fund rate. i_loan_period Effective loan rate per schedule period. i_fund_period Effective fund rate per schedule period. k Schedule frequency. |
| B04 | `accrued_interest` | `accrued_interest(.data = NULL, face = NULL, c = NULL, settlement = NULL, previous_coupon = NULL, next_coupon = NULL, k = 1L, day_count = "act/act", clean_price = NULL, dirty_price = NULL, tol = 1e-10)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble . For direct input, it contains the bond parameters, settlement/coupon dates, the chosen convention, coupon_per_period , days_elapsed , days_in_period , year_fraction , coupon_fraction , accrued_interest , clean_price , and dirty_price . For data-frame input, original columns are retained and the audit columns added. When neither price is supplied, both price columns contain NA_real_ . |
| B04 | `bond_book_value` | `bond_book_value(face, c, n, t, k = 1L, y_effective_per_period = NULL, y = NULL, y_type = "effective", y_m = 1L, R = NULL, tol = 1e-10, check = TRUE, tidy = FALSE)` | face primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric vector of book values, one for each t . If tidy = TRUE , a tibble with valuation times, valuation periods, book values, yield information, and bond inputs. |
| B04 | `bond_callable_price` | `bond_callable_price(face, c, n, k = 1L, call_t, call_R, y_effective_per_period = NULL, y = NULL, y_type = "effective", y_m = 1L, R = NULL, tol = 1e-10, check = TRUE, tidy = FALSE)` | face primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | If tidy = FALSE , a numeric scalar: the worst-case callable-bond price consistent with the target yield. If tidy = TRUE , a tibble with one row per redemption scenario, including scenario prices and the worst-case indicator. is_worst_case is TRUE exactly when a computed scenario price equals the computed minimum, including all exact computed ties. Near ties are not marked. |
| B04 | `bond_cash_flows` | `bond_cash_flows(face, c, n, k = 1L, R = NULL, tol = 1e-10, check = TRUE)` | face primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with the bond cash-flow schedule. The main actuarial columns are t for payment time and cf for cash flow. |
| B04 | `bond_convexity` | `bond_convexity(face, c, n, k = 1L, y_effective_per_period = NULL, y = NULL, y_type = "effective", y_m = 1L, R = NULL, tol = 1e-10, check = TRUE)` | face primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A one-row tibble with: price Dirty price at the given yield. discrete_convexity_periods Discrete convexity in coupon periods. discrete_convexity_years Discrete convexity in years. yield_per_period Effective yield per coupon period. yield_effective_annual Annual effective yield. k Coupon frequency. n_periods Total number of coupon periods. |
| B04 | `bond_duration` | `bond_duration(face, c, n, k = 1L, y_effective_per_period = NULL, y = NULL, y_type = "effective", y_m = 1L, R = NULL, tol = 1e-10, check = TRUE)` | face primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A one-row tibble with: price Dirty price at the given yield. macaulay_duration_periods Macaulay duration in coupon periods. macaulay_duration_years Macaulay duration in years. modified_duration_periods_j Modified duration with respect to the effective yield per coupon period, expressed in coupon periods. modified_duration_years_i Modified duration with respect to the annual effective yield, expressed in years. yield_per_period Effective yield per coupon period. yield_effective_annual Annual effective yield. k Coupon frequency. n_periods Total number of coupon periods. |
| B04 | `bond_price` | `bond_price(face, c, n, k = 1L, y_effective_per_period = NULL, y = NULL, y_type = "effective", y_m = 1L, R = NULL, tol = 1e-10, check = TRUE)` | face primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | Numeric scalar: dirty price of the bond at time 0. |
| B04 | `bond_ytm` | `bond_ytm(P, face, c, n, k = 1L, R = NULL, interval = NULL, tol = 1e-12, maxiter = 1000, check = TRUE)` | P primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A one-row tibble with columns: price Input dirty price. i_period Effective yield per coupon period. j_nominal Nominal annual yield convertible k times per year (= k * i_period ). When k = 2 , this is the bond-equivalent yield. i_effective_annual Annual effective yield. k Coupon frequency. |
| B04 | `bootstrap_spot_curve` | `bootstrap_spot_curve(.data, col_instrument = "instrument", col_price = "price", col_t = "t", col_cf = "cf")` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble ordered by maturity, with columns instrument , t , price , known_pv , terminal_cf , v , i , repriced_price , and repricing_error . The columns v and i contain the new maturity's discount factor and annual effective spot rate. repricing_error is the model price minus the observed dirty price, in monetary units. |
| B04 | `convexity_cash_flow` | `convexity_cash_flow(cf, t, rate, valuation_time = 0, output = c("value", "audit"))` | cf primero; pipe posicional posible, revisar pertinencia | `output = c("value", "audit")` | If `output = "value"`, a numeric scalar. If `output = "audit"`, a tibble with six columns: `time`, `remaining_time`, `cash_flow`, `discount_factor`, `present_value`, and `convexity_contribution`. |
| B04 | `duration_cash_flow` | `duration_cash_flow(cf, t, rate, valuation_time = 0, duration = c("macaulay", "modified"), output = c("value", "audit"))` | cf primero; pipe posicional posible, revisar pertinencia | `output = c("value", "audit")` | If `output = "value"`, a numeric scalar. If `output = "audit"`, a tibble with six columns: `time`, `remaining_time`, `cash_flow`, `discount_factor`, `present_value`, and `duration_contribution`. |
| B04 | `forward_curve` | `forward_curve(.data = NULL, t = NULL, i = NULL, col_t = "t", col_i = "i", col_curve = NULL, i_type = "effective", m = 1L, include_origin = TRUE)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble, with one row per forward interval and columns curve , t_start , t_end , duration , v_start , v_end , and f . f is an annual effective forward rate and duration is measured in years. |
| B04 | `forward_rate` | `forward_rate(.data = NULL, t = NULL, i = NULL, t_start = NULL, t_end = NULL, col_t = "t", col_i = "i", col_t_start = "t_start", col_t_end = "t_end", i_type = "effective", m = 1L, method = c("exact", "linear"), plot = FALSE, .out = "f", .out_plot = "forward_rate_plot", .keep = c("all", "used", "none"), .na = c("propagate", "error", "drop"))` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble. By default it returns the original columns plus a new numeric column named by .out . If plot = TRUE , it also adds a list-column named by .out_plot containing ggplot2 objects. |
| B04 | `immunize_duration` | `immunize_duration(L, t, P, D, i, i_type = "effective", m = 1L)` | L primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with: w Numeric vector of asset weights or units. PV_L Present value of the liabilities. D_L Macaulay duration of the liabilities. PV_A Present value of the immunized asset portfolio. D_A Macaulay duration of the asset portfolio. n_assets Number of assets used. |
| B04 | `immunize_duration_convexity` | `immunize_duration_convexity(L, t, P, D, C, i, i_type = "effective", m = 1L)` | L primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with: w Numeric vector of asset weights or units. PV_L Present value of the liabilities. D_L Macaulay duration of the liabilities. C_L Discrete convexity of the liabilities. PV_A Present value of the asset portfolio. D_A Macaulay duration of the asset portfolio. C_A Discrete convexity of the asset portfolio. n_assets Number of assets used. |
| B04 | `par_rate` | `par_rate(.data = NULL, t = NULL, i = NULL, n = NULL, face = 100, k = 1L, R = NULL, i_type = "effective", m = 1L, col_t = "t", col_i = "i", tol = 1e-10)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | One tibble row per curve, containing the supplied curve columns and n , face , k , R , annuity_factor , v_n , c_par , coupon_per_period , repriced_price , and repricing_error . The c_par value is the nominal annual coupon rate as a proportion; coupon_per_period is its monetary coupon amount. repricing_error is the reconstructed dirty price minus the face value. |
| B04 | `plot_immunization_gap` | `plot_immunization_gap(L, t, asset_cashflows, w, i, i_type = "effective", m = 1L, delta = 0.01, n_grid = 200L)` | L primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A ggplot2 object showing the PV difference curve PV_A(i) - PV_L(i) PV_A(i) - PV_L(i) and a zero reference line. |
| B04 | `portfolio_convexity` | `portfolio_convexity(.data = NULL, portfolio_id = NULL, P = NULL, C = NULL, col_portfolio = "portfolio_id", col_P = "P", col_C = "C", .out = "C_P", .out_value = "P_total", .out_n = "n_positions", .na = c("propagate", "error", "drop"), ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with one row per portfolio and columns for portfolio convexity, total portfolio value, and number of positions used. |
| B04 | `portfolio_duration` | `portfolio_duration(.data = NULL, portfolio_id = NULL, P = NULL, D = NULL, col_portfolio = "portfolio_id", col_P = "P", col_D = "D", .out = "D_P", .out_value = "P_total", .out_n = "n_positions", .na = c("propagate", "error", "drop"), ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with one row per portfolio and columns for portfolio duration, total portfolio value, and number of positions used. |
| B04 | `yield_curve` | `yield_curve(.data = NULL, t = NULL, i = NULL, col_t = "t", col_i = "i", i_type = "effective", m = 1L, plot = FALSE, .out = "v", .out_plot = "yield_curve_plot", .keep = c("all", "used", "none"), .na = c("propagate", "error", "drop"))` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble. By default, it returns the original columns plus a new list-column named by .out containing discount-factor vectors. If plot = TRUE , it also adds a list-column named by .out_plot containing ggplot2 objects. |
| B05 | `commutation_table` | `commutation_table(lt, i, i_type = "effective", m = 1L, check = TRUE)` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | A tibble with columns x , lx , dx , v , Dx , Nx , Sx , Cx , Mx , and Rx . |
| B05 | `e_x` | `e_x(lt, x, t = NULL, type = c("curtate", "complete"), frac, tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | A numeric vector of expected future lifetimes, or a tibble if tidy = TRUE with columns x , t , type , frac , ex . |
| B05 | `km_lifetable` | `km_lifetable(time, status, entry = NULL, breaks = NULL, radix = 1e+05, conf_level = 0.95, assumption = c("UDD", "CF", "Balducci"))` | time primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A list with two tibbles: km : tibble with columns time , n_risk , d , censored , S , varS , seS , ci_low , ci_high . lifetable : tibble with columns x , x_next , width , lx , dx , qx , px , mx , ax , Lx , Tx , ex . Carries class "lifetable" and standard attributes for compatibility with downstream functions. |
| B05 | `lifetable` | `lifetable(x, lx = NULL, qx = NULL, px = NULL, mx = NULL, radix = NULL, omega = NULL, close = TRUE, ax = 0.5, type = c("ultimate", "select"), frac = c("UDD", "CF", "Balducci"), check = TRUE, tol = 1e-10)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with class c("lifetable","tbl_df","tbl","data.frame") and columns: x : integer ages lx : survivors at exact age x dx : deaths in [x, x+1) qx : probability of death in [x, x+1) px : probability of survival to x+1 mx : central death rate (derived using ax ). At the terminal age with close = TRUE , mx equals 1/a_x and is Inf if ax = 0 . Attributes include: radix , omega , type , frac , closed , ax . |
| B05 | `lt_tau` | `lt_tau(md, ...)` | md primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A lifetable object as produced by lifetable . |
| B05 | `md_table` | `md_table(qx_df, age_col = "x", cause_cols = NULL, radix = 1e+05, close = TRUE, check = TRUE, tol = 1e-10)` | qx_df primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with columns: x : integer ages. lx : cohort \ell_x . q_total : total decrement probability q_x^{(\tau)} . p_total : total survival probability p_x^{(\tau)} . d_total : total decrements d_x^{(\tau)} = \ell_x q_x^{(\tau)} . cause columns (as provided). cause-specific decrements d_* with d_x^{(j)} = \ell_x q_x^{(j)} . |
| B05 | `mortality_law_table` | `mortality_law_table(law = c("Exponential", "Gompertz", "Makeham", "Weibull", "Logistic", "DeMoivre", "Beta", "HeligmanPollard"), x_min, x_max, ..., params = NULL, frac = c("CF", "UDD", "Balducci", "CML"), l0 = 1e+05, close = TRUE, a_x = 0.5, check = TRUE, tol = 1e-10, radix = NULL, ax = NULL)` | law primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with columns x , law , frac , mu_x , qx , px , lx , dx , Lx , Tx , ex , and mx . |
| B05 | `plot_km` | `plot_km(km, time_col = "time", surv_col = "S", lower_col = "ci_low", upper_col = "ci_high", conf_int = TRUE, title = NULL)` | km primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A ggplot object that can be further customised with additional ggplot2 layers. |
| B05 | `t_Ex` | `t_Ex(lt, x, t, i, i_type = "effective", m = 1L, frac, tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | Numeric vector of {}_tE_x , or a tibble if tidy = TRUE . |
| B05 | `t_px` | `t_px(lt, x, t, frac, tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | Numeric vector of {}_t p_x , or a tibble if tidy = TRUE . |
| B05 | `t_qx` | `t_qx(lt, x, t, frac, tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | Numeric vector of {}_t q_x , or a tibble if tidy = TRUE . |
| B05 | `t_qxj` | `t_qxj(md, x, t, cause, frac = NULL, tidy = FALSE, check = TRUE, tol = 1e-10)` | md primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | Numeric vector of {}_t q_x^{(j)} (or tibble if tidy=TRUE ). |
| B06 | `A_xj (alias de insurance_xj)` | `A_xj(md, x, i, cause, type = c("whole", "term"), benefit = 1, n = NULL, h = 0L, i_type = "effective", m = 1L, tidy = FALSE, check = TRUE, tol = 1e-10)` | md primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | Numeric vector of APVs, or a tibble if tidy = TRUE . |
| B06 | `add_insurance` | `add_insurance(contract, type = c("whole", "term", "endowment", "pure_endowment", "variable_k"), benefit = 1, n = Inf, h = 0L, k = 1L, frac = c("UDD", "CF", "CML", "Balducci"))` | contract primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | The original contract with an `insurance` component. |
| B06 | `add_premium_schedule` | `add_premium_schedule(contract, k = 1L, timing = c("due", "immediate"), premium_start = c("issue", "deferred"), n_prem = NULL, woolhouse = c("none", "first", "second"), frac = NULL)` | contract primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | The original contract with a `premium_schedule` component. |
| B06 | `annuity_multi` | `annuity_multi(lt, ages, i, i_type = "effective", m = 1L, n = NULL, h = 0L, k = 1L, annuity = c("cohort", "reversionary"), cohort = c("first", "last"), alpha = NULL, timing = c("immediate", "due"), woolhouse = c("none", "first", "second"), frac = c("UDD", "CF", "CML", "Balducci"))` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | A single numeric value representing the APV. |
| B06 | `annuity_x` | `annuity_x(lt, x, i, i_type = "effective", m = 1L, n = NULL, h = 0L, k = 1L, timing = c("immediate", "due"), woolhouse = c("none", "first", "second"), frac = NULL, tidy = FALSE)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | If tidy = FALSE , a numeric vector of actuarial present values, of length one for a single scenario. If tidy = TRUE , a tibble with one row per scenario, the main input values, equivalent interest rate, deferment factor, pure endowment factor, and APV. |
| B06 | `apv_life_flow` | `apv_life_flow(lt, ages, t = NULL, date = NULL, date0 = NULL, cf, i, i_type = "effective", m = 1L, status = c("single", "first", "last", "reversionary"), alpha = NULL, plot = FALSE)` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | A tibble with one row per payment and columns: t , cf , surv_prob , discount , expected_cf , pv , and pv_cum . If date was provided, a date column is included. The total APV is stored as attr(result, "apv") . The contingency attribute identifies "survival" or "weighted" (reversionary benefit fraction) for plot_contingent_cash_flow() . |
| B06 | `insurance_variable_k` | `insurance_variable_k(lt, x, i, benefit, n = NULL, h = 0, k = 12, i_type = "effective", m = 1L, frac, tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | A numeric actuarial present value, or a one-row tibble if tidy = TRUE . |
| B06 | `insurance_x` | `insurance_x(lt, x, i, i_type = "effective", m = 1L, n = Inf, h = 0L, type = c("whole", "term", "endowment"), benefit = 1, tidy = FALSE, ...)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | If tidy = FALSE , a numeric vector of actuarial present values, of length one for a single scenario. If tidy = TRUE , a tibble with one row per scenario, the main input values, equivalent interest rate, deferral factor, pure endowment factor, annuity-due value used in the standard identities, and APV. |
| B06 | `insurance_xj` | `insurance_xj(md, x, i, cause, type = c("whole", "term"), benefit = 1, n = NULL, h = 0L, i_type = "effective", m = 1L, tidy = FALSE, check = TRUE, tol = 1e-10)` | md primero; pipe posicional posible, revisar pertinencia | `tidy = FALSE` | Numeric vector of APVs, or a tibble if tidy = TRUE . |
| B06 | `life_contract` | `life_contract(lt, lives = c("single", "joint", "last_survivor"), x = NULL, y = NULL, i, i_type = "effective", m = 1L, ...)` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | An object of class `"tidyact_life_contract"`. |
| B06 | `plot_contingent_cash_flow` | `plot_contingent_cash_flow(.data, view = c("all", "contractual", "probability", "expected", "pv"), title = NULL, subtitle = NULL, x_label = NULL, show_labels = TRUE, label_size = 3.2, label_digits = 2L, label_format = c("auto", "full", "compact"), currency = "", col_inflow = "#1B9E77", col_outflow = "#D95F02", date_labels = "%Y-%m-%d")` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | An editable ggplot2 object. Its tibble data has one row per payment per selected measure: row , t , x , event , measure , value , plot_value and label . value retains original units; extreme monetary panels use scaled plot_value with the power of ten in the panel title. |
| B06 | `premium_gross` | `premium_gross(prem, alpha = 0, beta = 0, gamma = 0, k = NULL, output = c("value", "summary", "audit", "table"), tidy = NULL, check = TRUE, tol = 1e-10, ...)` | prem primero; pipe posicional posible, revisar pertinencia | `output = c("value", "summary", "audit", "table"); tidy = NULL` | For output = "value" , a numeric scalar containing the annualized gross premium G^{(k)} . For output = "summary" , a one-row tibble with six columns: annualized gross premium, gross premium per payment, annualized net premium, annualized loading, payment frequency, and equivalence residual. For output = "audit" , a long-format tibble with the APVs of gross premiums, benefits, and each expense component. |
| B06 | `premium_x` | `premium_x(lt, x, i, i_type = "effective", m = 1L, type = c("whole", "term", "endowment", "variable_k"), benefit = 1, n = Inf, h = 0L, k = 1L, frac = c("UDD", "CF", "CML", "Balducci"), timing = c("due", "immediate"), premium_start = c("issue", "deferred"), n_prem = NULL, woolhouse = c("none", "first", "second"), output = c("value", "summary", "audit"), tidy = NULL, check = TRUE, ...)` | lt primero; tabla/contrato según documentación | `output = c("value", "summary", "audit"); tidy = NULL` | For output = "value" , a numeric scalar containing the annualized premium P^{(k)} . For output = "summary" , a one-row tibble with six columns: annualized premium, premium per payment, payment frequency, APV of benefits, APV of the premium annuity, and equivalence residual. For output = "audit" , a long-format tibble containing the principal inputs and calculated components. |
| B06 | `reserve_x` | `reserve_x(lt, x, i, i_type = "effective", m = 1L, type = c("whole", "term", "endowment"), n = Inf, h = 0L, benefit = 1, P = NULL, k = 1L, frac = c("UDD", "CF", "CML", "Balducci"), timing = c("due", "immediate"), premium_start = c("issue", "deferred"), n_prem = NULL, woolhouse = c("none", "first", "second"), t = NULL, method = c("prospective", "recursive"), output = c("summary", "value", "audit", "table"), tidy = NULL, check = TRUE, ...)` | lt primero; tabla/contrato según documentación | `output = c("summary", "value", "audit", "table"); tidy = NULL` | For output = "summary" , a tibble with at most six columns: duration, attained age, reserve, annualized premium, premium per payment, and method. For output = "value" , a named numeric vector. For output = "audit" , a long-format tibble containing future benefit APV, future premium APV, reserve, and premium amounts at each duration. |
| B07 | `annuity_xy` | `annuity_xy(lt, x = NULL, y = NULL, i = NULL, i_type = "effective", m = 1L, status = c("joint", "last"), benefit = NULL, n = Inf, h = 0L, k = 1L, timing = c("immediate", "due"), woolhouse = c("none", "first", "second"), frac, tidy = FALSE, ...)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | If tidy = FALSE , a numeric scalar. If tidy = TRUE , a one-row tibble with input values, standardized interest rate, term used, and APV. |
| B07 | `e_xy` | `e_xy(lt, x, y, t = NULL, type = c("curtate", "complete"), frac, cohort = c("first", "last"), tidy = FALSE, check = TRUE, tol = 1e-10)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | Numeric vector, or tibble if tidy = TRUE . |
| B07 | `insurance_xy` | `insurance_xy(lt, x = NULL, y = NULL, i = NULL, i_type = "effective", m = 1L, type = c("whole", "term", "endowment"), status = c("joint", "last"), n = Inf, h = 0L, benefit = 1, frac, tidy = FALSE, ...)` | lt primero; tabla/contrato según documentación | `tidy = FALSE` | If tidy = FALSE , a numeric scalar. If tidy = TRUE , a one-row tibble with input values, standardized interest rate, deferment factor, unit APV, and APV. |
| B07 | `premium_xy` | `premium_xy(lt, x = NULL, y = NULL, i = NULL, i_type = "effective", m = 1L, type = c("whole", "term", "endowment", "pure_endowment"), benefit = 1, n = Inf, h = 0L, k = 1L, frac = c("UDD", "CF", "CML", "Balducci"), timing = c("due", "immediate"), premium_start = c("issue", "deferred"), n_prem = NULL, status = c("joint", "last"), woolhouse = c("none", "first", "second"), output = c("value", "summary", "audit", "table"), tidy = NULL, check = TRUE, tol = 1e-10, ...)` | lt primero; tabla/contrato según documentación | `output = c("value", "summary", "audit", "table"); tidy = NULL` | For output = "value" , a numeric scalar containing the annualized premium P^{(k)} . For output = "summary" , a one-row tibble with six columns: annualized premium, premium per payment, payment frequency, APV of benefits, APV of the premium annuity, and equivalence residual. For output = "audit" , a long-format tibble. |
| B07 | `reserve_xy` | `reserve_xy(lt, x = NULL, y = NULL, i = NULL, i_type = "effective", m = 1L, type = c("whole", "term", "endowment", "pure_endowment"), status = c("joint", "last"), n = Inf, h = 0L, benefit = 1, P = NULL, n_prem = NULL, k = 1L, timing = c("due", "immediate"), premium_start = c("issue", "deferred"), frac = c("UDD", "CF", "CML", "Balducci"), woolhouse = c("none", "first", "second"), t = NULL, method = c("prospective", "recursive"), output = c("summary", "value", "audit", "table"), tidy = NULL, check = TRUE, tol = 1e-10, ...)` | lt primero; tabla/contrato según documentación | `output = c("summary", "value", "audit", "table"); tidy = NULL` | A compact tibble, a named numeric vector, or a long audit tibble. |
| B07 | `t_pxy` | `t_pxy(lt, x, y, t, frac, status = c("joint", "last"))` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | A single numeric value. |
| B08 | `mc_annuity` | `mc_annuity(.data = NULL, i, payment = 1, k = 1L, type = c("whole", "temporary", "deferred", "deferred_temporary", "certain", "guaranteed", "whole_life"), n = NULL, h = 0, n_guar = NULL, timing = c("immediate", "due"), i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"), m = 1, col_K = "Kx", col_T = "Tx", col_pv = "pv_annuity", ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with the original simulation columns and additional columns: i Original interest-rate input. i_type Interest-rate convention. m Interest conversion frequency. i_effective Equivalent annual effective interest rate. v Annual discount factor. type Canonical annuity type. payment Legacy-compatible amount of each annuity payment. payment_per_payment Amount paid at each payment date. payment_annualized Payment amount multiplied by the number of payments per year. k Annuity payment frequency. n Annuity term, if applicable. h Deferral period. n_guar Guaranteed period, if applicable. timing Annuity payment timing. n_payments Number of payments made in the simulated scenario. first_payment_time First payment time in the simulated scenario. last_payment_time Last payment time in the simulated scenario. pv_annuity Simulated present value of annuity payments, or another name supplied through col_pv . For transition, the output also includes legacy columns such as rate , interest_type , effective_rate , discount_factor , annuity , payments_per_year , term , deferral_years , and guarantee_years . |
| B08 | `mc_insurance` | `mc_insurance(.data = NULL, i = NULL, benefit = 1, type = c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment", "whole_life", "deferred_temporary"), n = NULL, h = 0, timing = c("end_of_year", "moment_of_death"), i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"), m = 1, col_K = "Kx", col_T = "Tx", col_pv = "pv_benefit", ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with the original simulation columns and additional columns: i Original interest-rate input. i_type Interest-rate convention. m Interest conversion frequency. i_effective Equivalent annual effective interest rate. v Annual discount factor. type Canonical insurance type. benefit Benefit amount. n Insurance term, if applicable. h Deferral period. timing Timing used for death benefits. benefit_time Simulated payment time of the benefit. benefit_indicator Indicator that the benefit is paid. pv_benefit Simulated present value of the benefit, or another name supplied through col_pv . For transition, the output also includes legacy columns such as rate , interest_type , effective_rate , discount_factor , insurance , term , deferral_years , and payment_timing . |
| B08 | `mc_loss` | `mc_loss(.data = NULL, col_Z = "pv_benefit", col_Y = "pv_annuity", col_P = "P", col_L = "L", P = NULL, premium_unit = c("auto", "annualized", "per_payment", "annuity_scale"), k = NULL, annuity_payment = NULL, tol = 1e-10, ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble containing the original simulation and standardized columns: premium_annualized Annualized premium P^{(k)} . premium_per_payment Amount collected at each premium date. payments_per_year Premium payment frequency k . premium_annuity_scale Coefficient multiplying col_Y . pv_premiums Simulated present value of premium income. L Simulated loss, or the name supplied through col_L . A compatibility column loss is synchronized with col_L . |
| B08 | `mc_multilife_status` | `mc_multilife_status(data, status = c("joint", "last_survivor"), col_sim = "sim_id", col_life = "life_id", col_K = "Kx", col_T = "Tx", tol = 1e-10)` | data primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with one row per simulation and: sim_id Standard simulation identifier. sim Compatibility alias for the simulation identifier. K_status Curtate future lifetime of the status. T_status Complete future lifetime of the status. n_lives Number of lives represented in each simulation. status Canonical status: "joint" or "last_survivor" . If col_sim is neither "sim_id" nor "sim" , that original identifier column is also retained. |
| B08 | `mc_premium` | `mc_premium(.data = NULL, col_Z = "pv_benefit", col_Y = "pv_annuity", col_P = "P", by = NULL, na_rm = TRUE, k = NULL, annuity_payment = NULL, tol = 1e-10, ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble containing the original simulations and standardized premium columns: premium_annualized Estimated annualized premium \widehat P^{(k)} . premium_per_payment Amount collected at each premium date. payments_per_year Premium payment frequency k . premium_annuity_scale Coefficient \widehat q multiplying col_Y . mc_equivalence_residual Difference \overline Z-\widehat q\overline{Y_c} within the estimation group. The column selected by col_P stores premium_annuity_scale for backward compatibility. Unless col_P = "premium" , a compatibility column premium is also created with the same scale coefficient. |
| B08 | `mc_reserve` | `mc_reserve(.data = NULL, t = 0, i = NULL, P = NULL, col_P = "P", premium_unit = c("auto", "annualized", "per_payment", "annuity_scale"), benefit = 1, payment = 1, k = 1L, type = c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment", "whole_life", "deferred_temporary"), annuity_type = c("whole", "temporary", "deferred", "deferred_temporary", "certain", "guaranteed", "whole_life"), n = NULL, h = 0, n_guar = NULL, timing = c("end_of_year", "moment_of_death"), premium_timing = c("due", "immediate"), reserve_timing = c("before_payment", "after_payment"), i_type = c("effective", "nominal_interest", "nominal_discount", "force", "nominal"), m = 1, col_K = "Kx", col_T = "Tx", in_force_basis = c("auto", "complete", "curtate"), not_in_force = c("na", "zero"), col_L = "L_t", tol = 1e-10, premium = NULL, ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with one row per simulation and requested duration. Important standardized columns include: Z_t Future benefit present value at duration t . Y_t Future premium-annuity basis present value. future_pv_premiums Actual future premium present value. premium_annualized Annualized premium P^{(k)} . premium_per_payment Premium paid at each date. premium_annuity_scale Coefficient multiplying Y_t . L_t Prospective loss, or the name supplied through col_L . |
| B08 | `simulate_annuity_x` | `simulate_annuity_x(lt, x = NULL, i = NULL, i_type = NULL, m = NULL, n = Inf, k = 1L, timing = c("due", "immediate"), payment = 1, frac = c("udd", "cml", "balducci"), method = c("inverse"), n_sim = 10000L, seed = NULL, output = c("simulations", "summary"), ...)` | lt primero; tabla/contrato según documentación | `output = c("simulations", "summary")` | A tibble with one row per simulation, or a summary from summary_mc . Simulation output includes payment_per_payment , payment_annualized , Kx , Tx , n_payments , present_value , and pv_annuity . |
| B08 | `simulate_insurance_x` | `simulate_insurance_x(lt, x = NULL, i = NULL, i_type = NULL, m = NULL, type = c("whole", "term", "endowment"), n = Inf, benefit = 1, method = c("inverse"), n_sim = 10000L, seed = NULL, output = c("simulations", "summary"), ...)` | lt primero; tabla/contrato según documentación | `output = c("simulations", "summary")` | A tibble with one row per simulation, or a summary. Simulation output includes benefit_indicator , benefit_time , present_value , and pv_benefit . |
| B08 | `simulate_lifetime` | `simulate_lifetime(lt, x, n_sim = 10000L, x_col = "x", qx_col = "qx", method = c("inverse", "multinomial", "antithetic"), frac = c("udd", "cml", "balducci", "none", "constant_force"), seed = NULL, include_distribution = FALSE, truncation = c("conditional", "error"), tol = 1e-10)` | lt primero; tabla/contrato según documentación | `Sin selector con esos nombres; ver retorno` | A tibble with one row per simulation and standardized columns including sim_id , Kx , curtate_lifetime , Tx , complete_lifetime , death_age , method , and frac . The logical column distribution_conditioned indicates whether a truncated table was normalized conditionally. |
| B08 | `simulate_lifetimes` | `simulate_lifetimes(data, x, n_sim = 1000L, frac = c("udd", "cml", "balducci", "constant", "cfm", "constant_force"), method = c("inverse", "multinomial", "antithetic"), seed = NULL, truncation = c("conditional", "error"), tol = 1e-10)` | data primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with one row per simulation and life. Standard columns include sim_id , simulation_id , life_id , x , Kx , curtate_lifetime , Tx , complete_lifetime , death_age , method , and frac . Compatibility aliases sim , life , K , and T are retained. |
| B08 | `summary_mc` | `summary_mc(.data = NULL, col_value = "present_value", by = NULL, probs = c(0.025, 0.5, 0.975), var_probs = c(0.95, 0.99), na_rm = TRUE, ...)` | .data primero; entrada tabular explícita | `Sin selector con esos nombres; ver retorno` | A tibble with summary statistics. |
| B09 | `aggregate_distribution` | `aggregate_distribution(x, method = c("auto", "analytic", "convolution", "panjer", "fft"), tol = 1e-08, max_loss = NULL, ...)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object with classes "tidyact_aggregate_distribution" and "tidyact_risk_distribution" . It contains: schema_version Internal schema version. method The computational method actually used. grid A tibble with loss , probability , and cdf . support Support information for the retained grid. tail_probability Probability not represented on the retained grid. model The source collective risk specification. label The model label, if any. metadata Audit information about method selection, truncation, exactness, and numerical controls. |
| B09 | `aggregate_moments` | `aggregate_moments(x, order = 1:4, type = "raw")` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble::tibble() with one row per requested order and columns: type , order , value , and status . |
| B09 | `apply_coverage` | `apply_coverage(x, coverage, label = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An S3 object with classes tidyact_payment_spec , tidyact_severity_spec , and tidyact_distribution_spec . The list stores source , coverage , basis = "per_loss" , label , and a normalized severity specification ( dist = "discrete" for finite discrete losses or dist = "custom" for continuous and mixed losses). The support bound is not asserted to be the smallest possible bound under the original distribution. |
| B09 | `collective_risk_spec` | `collective_risk_spec(frequency, severity, count_basis = NULL, label = NULL)` | frequency primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object with classes "tidyact_collective_risk_spec" and "tidyact_risk_spec" . It contains the following fields: schema_version : internal schema version. frequency : the frequency specification. severity : the severity specification. count_basis : either "loss" or "payment" . label : optional user label. metadata : reserved metadata list. |
| B09 | `coverage_spec` | `coverage_spec(deductible = 0, limit = Inf, coinsurance = 1, inflation_factor = 1, deductible_type = c("ordinary", "franchise"), index_deductible = FALSE, index_limit = FALSE, label = NULL)` | deductible primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object of class tidyact_coverage_spec , implemented as a named list containing deductible , limit , coinsurance , inflation_factor , deductible_type , index_deductible , index_limit , and label . No derived payments or distributional quantities are stored. |
| B09 | `discretize_severity` | `discretize_severity(x, step, to = NULL, method = c("unbiased", "upper", "lower", "rounding"), tail_prob = 1e-08, label = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tidyact_severity_spec and tidyact_distribution_spec object with dist = "discrete" , lattice support, and discretization information in metadata$discretization . The metadata records: method ; step ; to ; whether to was supplied or selected from tail_prob ; the requested tail_prob when applicable; the actual probability above to ; the explicit tail treatment; the original distribution identifier; and the source of the limited mean for the unbiased method. |
| B09 | `distribution_convolution` | `distribution_convolution(x, y = NULL, n = NULL, label = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | For a genuine convolution, an object with classes "tidyact_convolution_spec" and "tidyact_distribution_spec" . The object follows the common distribution specification schema: schema_version Internal schema version. dist The identifier "convolution" . params The lazy convolution definition. support Inferred support information. data Always NULL . custom Always NULL . label Optional user label. metadata Reserved metadata list. When n = 1 , the original distribution specification is returned instead of wrapping it in a convolution object. |
| B09 | `distribution_moments` | `distribution_moments(x, order = 1:4, type = "raw")` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble::tibble() with one row per requested order and columns: type (character), order (integer), value (double), and status (character). Input order and repeated orders are preserved. Undefined values are returned as NA_real_ . |
| B09 | `empirical_frequency` | `empirical_frequency(data, count = NULL, weight = NULL, label = NULL)` | data primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object of classes "tidyact_frequency_spec" and "tidyact_distribution_spec" , with the ordered fields schema_version , dist , params , support , data , custom , label , and metadata . The data field is a tibble::tibble() with columns count , weight , and probability , one row per count with positive empirical mass. |
| B09 | `empirical_severity` | `empirical_severity(data, amount = NULL, weight = NULL, label = NULL)` | data primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object with classes "tidyact_severity_spec" and "tidyact_distribution_spec" , containing schema_version , dist , params , support , data , custom , label , and metadata . The data field is a tibble::tibble() with amount , weight , and probability columns, sorted by amount. Only observed amounts with positive empirical probability are retained. |
| B09 | `frequency_spec` | `frequency_spec(dist, ..., custom = NULL, label = NULL)` | dist primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object with classes `"tidyact_frequency_spec"` and `"tidyact_distribution_spec"`. |
| B09 | `severity_spec` | `severity_spec(dist, ..., custom = NULL, label = NULL)` | dist primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | An object with classes "tidyact_severity_spec" and "tidyact_distribution_spec" . The ordered fields are schema_version , dist , params , support , data , custom , label , and metadata . Its data field is NULL ; empirical severities are handled separately. |
| B09 | `simulate_aggregate` | `simulate_aggregate(x, n_sim = 1000L, seed = NULL, max_claims = 1000000L)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `simulation`, `claim_count`, and `aggregate_loss`. |
| B09 | `simulate_frequency` | `simulate_frequency(x, n_sim = 1000L, seed = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `simulation` and `claim_count` columns. |
| B09 | `simulate_severity` | `simulate_severity(x, n_sim = 1000L, seed = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `simulation` and `claim_amount` columns. |
| B09 | `stop_loss_premium` | `stop_loss_premium(x, retention = 0, value = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `retention`, `premium`, and `method`. |
| B09 | `tail_value_at_risk` | `tail_value_at_risk(x, level = 0.95, value = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `level`, `tail_value_at_risk`, and `method`. |
| B09 | `to_payment_basis` | `to_payment_basis(x, label = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | For q > 0 , a tidyact_payment_basis_spec that also inherits from tidyact_collective_risk_spec , with thinned frequency, conditional positive severity, count_basis = "payment" , the unchanged source, and metadata. For q = 0 , an explicit tidyact_zero_payment_basis_spec with no per-payment severity, since conditioning on zero-probability events is undefined. This degenerate result is not a collective risk specification. |
| B09 | `value_at_risk` | `value_at_risk(x, level = 0.95, value = NULL)` | x primero; pipe posicional posible, revisar pertinencia | `Sin selector con esos nombres; ver retorno` | A tibble with `level`, `value_at_risk`, and `method`. |

## Cobertura de extracción

- Entradas públicas: 102.
- Apariciones de parámetros, incluyendo alias y ...: 974.
- Apariciones sin descripción Rd: 0.
- Todas las apariciones tienen descripción; esto no garantiza dominio o unidades completos.

## Fichas de parámetros

## B01 — accumulation_factor

Documentación: `man/accumulation_factor.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `s` | `0` | Numeric vector of starting times. Defaults to 0. |
| `t` | `<obligatorio>` | Numeric vector of ending times. |
| `i` | `NULL` | Optional numeric vector of conventional interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the conventional interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . Used only when i is supplied. |
| `m` | `1` | Positive integer vector giving the conversion frequency for nominal rates. Used only when i is supplied. |
| `a` | `NULL` | Optional accumulation function of one numeric time argument. The function must return one positive finite numeric value for each supplied time. |
| `delta` | `NULL` | Optional force-of-interest function of one numeric time argument. Numerical integration is performed separately over each interval [s,t] . |
| `subdivisions` | `100L` | Positive integer giving the maximum number of subintervals used by stats::integrate() when delta is supplied. |
| `rel.tol` | `1e-08` | Positive relative tolerance passed to stats::integrate() when delta is supplied. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric vector. If TRUE , returns a tibble with the inputs and intermediate quantities. |

## B01 — discount_factor

Documentación: `man/discount_factor.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `s` | `0` | Numeric vector of valuation times. Defaults to 0. |
| `t` | `<obligatorio>` | Numeric vector of payment or accumulation times. |
| `i` | `NULL` | Optional numeric vector of conventional interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the conventional interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . Used only when i is supplied. |
| `m` | `1` | Positive integer vector giving the conversion frequency for nominal rates. Used only when i is supplied. |
| `a` | `NULL` | Optional accumulation function of one numeric time argument. |
| `delta` | `NULL` | Optional force-of-interest function of one numeric time argument. |
| `subdivisions` | `100L` | Positive integer giving the maximum number of subintervals used by stats::integrate() when delta is supplied. |
| `rel.tol` | `1e-08` | Positive relative tolerance passed to stats::integrate() when delta is supplied. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric vector. If TRUE , returns a tibble with the inputs, accumulation factor, and discount factor. |

## B01 — discount_factor_spot

Documentación: `man/discount_factor_spot.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `t` | `<obligatorio>` | Numeric vector of times in years. Each value must be greater than or equal to 0. |
| `i` | `<obligatorio>` | Numeric vector of spot-rate values. |
| `i_type` | `"effective"` | Character vector indicating the spot-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal spot-rate inputs. Observed values are validated as positive integers for every family, even when the conversion itself does not use m . |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric discount factor. If TRUE , returns a tibble with intermediate calculations. |

## B01 — interest_equivalents

Documentación: `man/interest_equivalents.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `i_type` | `c("effective", "nominal_interest", "nominal_discount", "force")` | Character string indicating the input interest-rate type. Must be one of "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `i` | `<obligatorio>` | Numeric scalar giving the interest-rate value. |
| `m` | `1L` | Positive integer scalar giving the conversion frequency for nominal rates. |

## B01 — standardize_interest

Documentación: `man/standardize_interest.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Must be one of "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `m` | `1` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older internal calls using type = and rate = . These names are accepted and mapped to i_type and i . |

## B02 — future_value

Documentación: `man/future_value.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `C` | `<obligatorio>` | Numeric vector of initial payment amounts or capitals. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1` | Positive integer vector giving the conversion frequency for nominal rates. Observed values are validated as positive integers for all rate families; only nominal conversions use their numeric value. |
| `t` | `<obligatorio>` | Numeric vector of times in years from valuation to accumulation. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric future value. If TRUE , returns a tibble with intermediate calculations. |

## B02 — fv_flow

Documentación: `man/fv_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash flows. |
| `i` | `<obligatorio>` | Numeric scalar or numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . May have length 1 or the same length as cf . |
| `m` | `1L` | Conversion frequency for nominal rates. Must contain positive integers for nominal conversions and is ignored by other rate families. May have length 1 or the same length as cf . |
| `t` | `NULL` | Optional numeric vector of cash-flow times in years. |
| `date` | `NULL` | Optional vector of cash-flow dates. If supplied, the earliest date is treated as time 0. |
| `day_count` | `c("act/365", "act/360")` | Day-count convention used to convert dates to year fractions. One of "act/365" or "act/360" . |
| `tol` | `1e-10` | Numeric tolerance used in internal checks. |

## B02 — irr_flow

Documentación: `man/irr_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash flows. |
| `t` | `NULL` | Optional numeric vector of cash-flow times in years. |
| `date` | `NULL` | Optional vector of cash-flow dates. If supplied, the earliest date is treated as time 0. |
| `m` | `1L` | Positive integer used only to report an equivalent nominal annual interest rate convertible m times per year. |
| `interval` | `c(-0.99, 10)` | Numeric vector of length 2 giving the search interval for the annual effective IRR. Default is c(-0.99, 10) . |
| `tol` | `1e-10` | Numeric tolerance passed to uniroot . |
| `maxiter` | `1000` | Maximum number of iterations passed to uniroot . |
| `day_count` | `c("act/365", "act/360")` | Day-count convention used when date is supplied. One of "act/365" or "act/360" . |

## B02 — irr_flow_multi

Documentación: `man/irr_flow_multi.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash flows. |
| `t` | `NULL` | Optional numeric vector of cash-flow times in years. |
| `date` | `NULL` | Optional vector of cash-flow dates. If supplied, the earliest date is treated as time 0. |
| `m` | `1L` | Positive integer used only to report an equivalent nominal annual interest rate convertible m times per year. |
| `search_interval` | `c(-0.99, 10)` | Numeric vector of length 2 giving the search interval for annual effective IRRs. Default is c(-0.99, 10) . |
| `grid_points` | `2000L` | Positive integer giving the number of grid points used to scan the interval. Larger values improve detection at the cost of speed. |
| `tol` | `1e-10` | Numeric tolerance passed to uniroot . |
| `maxiter` | `1000L` | Positive integer passed to uniroot . |
| `day_count` | `c("act/365", "act/360")` | Day-count convention used when date is supplied. One of "act/365" or "act/360" . |

## B02 — plot_cash_flow

Documentación: `man/plot_cash_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | Optional data.frame or tibble containing cash-flow columns. |
| `C` | `<obligatorio>` | Numeric vector of cash flows, or a column name when .data is supplied. |
| `t` | `NULL` | Optional numeric vector of times in years, or a column name when .data is supplied. |
| `date` | `NULL` | Optional date vector, or a column name when .data is supplied. |
| `i` | `NULL` | Optional annual interest-rate input used to compute present value if PV is NULL . |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. |
| `PV` | `NULL` | Optional numeric present value to display. |
| `payment` | `NULL` | Deprecated. Use C . |
| `time` | `NULL` | Deprecated. Use t . Kept explicit to avoid partial matching with timeline_size . |
| `rate` | `NULL` | Deprecated. Use i . |
| `pv` | `NULL` | Deprecated. Use PV . |
| `title` | `NULL` | Optional plot title. |
| `subtitle` | `NULL` | Optional plot subtitle. |
| `x_label` | `NULL` | Optional x-axis label. |
| `amount_label` | `"Cash flow"` | Optional y-axis label when normalize = FALSE . |
| `financial` | `TRUE` | Logical. If TRUE , positive cash flows point upward and negative cash flows point downward. |
| `normalize` | `FALSE` | Logical. If TRUE , arrow heights are normalized. |
| `aggregate` | `TRUE` | Logical. If TRUE , cash flows occurring at the same time or date are summed before plotting. |
| `show_labels` | `TRUE` | Logical. If TRUE , labels are shown next to cash-flow arrows. |
| `label_size` | `3.5` | Numeric text size for labels. |
| `arrow_size` | `0.8` | Numeric line width for arrows. |
| `timeline_size` | `0.7` | Numeric line width for the time axis. |
| `label_digits` | `2L` | Integer between 0 and 50: decimal digits for cash-flow labels. |
| `label_format` | `c("auto", "full", "compact")` | Character string controlling label notation. Use "auto" to abbreviate values from one million onward, "full" for unabridged values, or "compact" for abbreviated values such as 1.25M . |
| `currency` | `""` | Optional currency or unit prefix, such as $ . |
| `col_inflow` | `"#1B9E77"` | Character color for inflow arrows. |
| `col_outflow` | `"#D95F02"` | Character color for outflow arrows. |
| `date_labels` | `"%Y-%m-%d"` | Character date-label format passed to ggplot2::scale_x_date() . |
| `day_count` | `c("act/365", "act/360")` | Day-count convention used when date is supplied. |
| `...` | `<argumentos adicionales; sin default>` | Reserved for future extensions. |

## B02 — present_value

Documentación: `man/present_value.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `C` | `<obligatorio>` | Numeric vector of future payment amounts or capitals. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1` | Positive integer vector giving the conversion frequency for nominal rates. Observed values are validated as positive integers for all rate families; only nominal conversions use their numeric value. |
| `t` | `<obligatorio>` | Numeric vector of times in years until payment. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric present value. If TRUE , returns a tibble with intermediate calculations. |

## B02 — pv_flow

Documentación: `man/pv_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash flows. |
| `i` | `<obligatorio>` | Numeric scalar or numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . May have length 1 or the same length as cf . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. May have length 1 or the same length as cf . |
| `t` | `NULL` | Optional numeric vector of cash-flow times in years. |
| `date` | `NULL` | Optional vector of cash-flow dates. If supplied, the earliest date is treated as time 0. |
| `day_count` | `c("act/365", "act/360")` | Day-count convention used to convert dates to year fractions. One of "act/365" or "act/360" . |

## B02 — solve_value

Documentación: `man/solve_value.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `fn` | `<obligatorio>` | A function, or the name of a function, whose scalar result is to be matched to `target`. |
| `solve_for` | `<obligatorio>` | Character scalar. Name of the scalar argument to solve for. |
| `target` | `<obligatorio>` | Finite numeric scalar. Desired value of the selected result. |
| `args` | `list()` | Named list containing all known arguments passed to `fn`. Do not supply a non-`NULL` value for the argument named in `solve_for`. |
| `result` | `NULL` | Optional result extractor. Use `NULL` when `fn` returns a numeric scalar; a character scalar naming a column or list element; or a function that extracts a numeric scalar from the object returned by `fn`. |
| `interval` | `NULL` | Optional finite numeric vector of length 2. It defines the admissible search interval. When omitted, a conservative interval is inferred from `solve_for`, `target`, and the numeric values in `args`. |
| `start` | `NULL` | Optional finite numeric scalar used as the initial value for Newton--Raphson. It is also used as a fallback starting point when `method = "auto"` cannot bracket a root. |
| `derivative` | `NULL` | Optional function of one argument returning the derivative of the equation residual with respect to the unknown. When omitted under Newton--Raphson, a central finite-difference derivative is used. |
| `method` | `c("auto", "uniroot", "newton")` | Character scalar. One of `"auto"`, `"uniroot"`, or `"newton"`. The default first searches for bracketed roots and uses Newton--Raphson only when no bracket is found and `start` is available. |
| `multiple` | `c("error", "all", "first")` | Character scalar controlling multiple roots found inside the interval: `"error"`, `"all"`, or `"first"`. |
| `tol` | `1e-10` | Positive finite numeric scalar controlling unknown-coordinate precision: passed to `uniroot`, used relatively for Newton corrections, and used when identifying duplicate roots. |
| `maxiter` | `1000L` | Positive integer. Maximum number of iterations. |
| `scan_points` | `401L` | Positive integer. Number of points used to detect sign changes and possible multiple roots. |
| `max_expand` | `6L` | Nonnegative integer. Maximum number of automatic interval expansions when an interval was inferred and a bracket is not found initially. An interval supplied explicitly by the user is never expanded. |
| `output` | `c("value", "summary", "audit")` | Character scalar. One of `"value"`, `"summary"`, or `"audit"`. |
| `residual_tol` | `tol` | Positive finite numeric scalar. Absolute residual tolerance in the units of the selected result of `fn`. Defaults to `tol`. |

## B03 — a_angle

Documentación: `man/a_angle.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `n` | `NULL` | Numeric vector of payment durations in years. Ignored when perpetuity = TRUE . If perpetuity = FALSE , each value must be positive and finite. |
| `k` | `1L` | Positive integer vector giving the number of discrete payments per year. Ignored for continuous annuities. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `h` | `0` | Numeric vector of deferment times in years. Must be greater than or equal to 0. |
| `timing` | `"immediate"` | Character vector. One of "immediate" , "due" , or "continuous" . |
| `perpetuity` | `FALSE` | Logical vector. If TRUE , computes the perpetuity factor. |
| `payment` | `1` | Numeric vector of level payment amounts. Used only when tidy = TRUE to report the corresponding present value. The annuity factor itself is always computed for unit payments. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric annuity factor. If TRUE , returns a tibble with intermediate calculations. |

## B03 — amort_schedule

Documentación: `man/amort_schedule.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `principal` | `<obligatorio>` | Numeric scalar. Initial outstanding balance. |
| `n` | `<obligatorio>` | Positive integer. Number of contractual periods. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the annual interest-rate type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal annual rates. |
| `k` | `1L` | Positive integer. Number of amortization periods per year. |
| `timing` | `c("immediate", "due")` | Character string. One of "immediate" or "due" . |
| `payment` | `NULL` | Optional numeric scalar. Initial regular payment per period. If NULL , it is computed from the loan data. |
| `extra_principal` | `NULL` | Optional extra principal payments. Can be: NULL , a scalar, an unnamed numeric vector of length n , a named numeric vector with names interpreted as period numbers. |
| `adjust` | `c("none", "term", "payment")` | Character string. One of "none" , "term" , or "payment" . |
| `tol` | `1e-08` | Finite positive numeric tolerance in monetary units for zero-balance detection. |

## B03 — amort_schedule_general

Documentación: `man/amort_schedule_general.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `principal` | `<obligatorio>` | Positive numeric scalar. Initial outstanding balance. |
| `n` | `<obligatorio>` | Positive integer scalar. Maximum number of amortization periods. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate inputs. It must have length 1 or n . A scalar is recycled over all periods. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . It must have length 1 or n . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. It must have length 1 or n . |
| `k` | `1L` | Positive integer scalar. Number of amortization periods per year. |
| `timing` | `c("immediate", "due")` | Character scalar. Either "immediate" for payments at the end of each period or "due" for payments at the beginning. |
| `payment` | `NULL` | Payment specification. It may be: NULL , in which case a level payment is calculated; a nonnegative numeric scalar; a nonnegative numeric vector of length n ; a function with arguments period , ob_start , and i_effective_period , returning one nonnegative payment. |
| `extra_principal` | `0` | Optional nonnegative extra-principal payments. It may be a scalar or a numeric vector of length n . Defaults to zero. |
| `output` | `c("schedule", "summary")` | Character scalar. Either "schedule" for the complete amortization table or "summary" for a compact actuarial summary. |
| `tol` | `1e-08` | Finite positive numeric scalar in monetary units used for zero-balance detection and the negative-amortization threshold. |

## B03 — annuity_arith

Documentación: `man/annuity_arith.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `n` | `<obligatorio>` | Numeric vector of payment durations in years. Each value must be positive and finite. |
| `k` | `1L` | Positive integer vector giving the number of payments per year. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Observed values are validated for every rate family, although only nominal conversions use this frequency. |
| `h` | `0` | Numeric vector of deferment times in years. Must be greater than or equal to 0. |
| `timing` | `"immediate"` | Character vector. One of "immediate" or "due" . |
| `pattern` | `"increasing"` | Character vector. One of "increasing" , "decreasing" , or "custom" . |
| `P1` | `1` | Numeric vector. First payment for pattern = "custom" . Ignored for "increasing" and "decreasing" . |
| `g` | `1` | Numeric vector. Arithmetic increment for pattern = "custom" . Ignored for "increasing" and "decreasing" . |
| `valuation` | `c("present", "accumulated")` | Character string. Use "present" for present value or "accumulated" for accumulated value at the end of the term. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric factor. If TRUE , returns a tibble with intermediate quantities. |

## B03 — annuity_geom

Documentación: `man/annuity_geom.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `n` | `NULL` | Numeric vector of payment durations in years. Ignored only when perpetuity = TRUE and valuation = "present" . Otherwise, each value must be positive and finite. |
| `k` | `1L` | Positive integer vector giving the number of payments per year. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal interest-rate inputs. Observed values are validated for every rate family, although only nominal conversions use this frequency. |
| `g` | `0` | Numeric vector of annual growth-rate values for the payments. |
| `g_type` | `"effective"` | Character vector indicating the growth-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `g_m` | `1L` | Positive integer vector giving the conversion frequency for nominal growth-rate inputs. Observed values are validated for every rate family, although only nominal conversions use this frequency. |
| `h` | `0` | Numeric vector of deferment times in years. Must be greater than or equal to 0. For present values, the deferment discounts the payment block. For accumulated values, it is recorded but does not change the factor under the adopted terminal-horizon convention. |
| `timing` | `"immediate"` | Character vector. One of "immediate" or "due" . |
| `P1` | `1` | Numeric vector giving the first payment of the geometric sequence. |
| `perpetuity` | `FALSE` | Logical vector. If TRUE , computes the geometric perpetuity present value. Perpetuities are not supported for valuation = "accumulated" . |
| `valuation` | `c("present", "accumulated")` | Character string. Use "present" for present value or "accumulated" for accumulated value at the end of the term. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric factor. If TRUE , returns a tibble with intermediate quantities. |

## B03 — s_angle

Documentación: `man/s_angle.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `n` | `<obligatorio>` | Numeric vector of payment durations in years. Each value must be positive and finite. |
| `k` | `1L` | Positive integer vector giving the number of discrete payments per year. Ignored for continuous annuities. |
| `i` | `<obligatorio>` | Numeric vector of interest-rate values. |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `h` | `0` | Numeric vector of deferment times in years. Must be greater than or equal to 0. Under the adopted horizon convention, this is metadata only for accumulation factors. |
| `timing` | `"immediate"` | Character vector. One of "immediate" , "due" , or "continuous" . |
| `payment` | `1` | Numeric vector of level payment amounts. Used only when tidy = TRUE to report the corresponding future value. The accumulation factor itself is always computed for unit payments. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric accumulation factor. If TRUE , returns a tibble with intermediate calculations. |

## B03 — sinking_fund_schedule

Documentación: `man/sinking_fund_schedule.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `principal` | `<obligatorio>` | Numeric scalar. Initial loan amount. |
| `n` | `<obligatorio>` | Positive integer. Number of schedule periods. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input for the loan. |
| `j` | `<obligatorio>` | Numeric scalar. Annual accumulation-rate input for the sinking fund. |
| `k` | `1L` | Positive integer. Number of schedule periods per year. |
| `i_type` | `"effective"` | Character string indicating the loan interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `j_type` | `"effective"` | Character string indicating the sinking-fund accumulation-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal loan rates. Validated for every rate family, although it affects conversion only for nominal rates. |
| `j_m` | `1L` | Positive integer. Conversion frequency for nominal sinking-fund rates. Validated for every rate family, although it affects conversion only for nominal rates. |
| `deposit` | `NULL` | Optional numeric scalar. Level sinking-fund deposit per period. If NULL , it is computed so that the fund accumulates to principal at the end of period n ( n / k years). |
| `tol` | `1e-08` | Finite positive numeric tolerance in monetary units used for final-balance checks. |

## B04 — accrued_interest

Documentación: `man/accrued_interest.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | Optional data frame containing one bond per row. Required columns are face , c , settlement , previous_coupon , and next_coupon . Optional columns are k , day_count , clean_price , and dirty_price . Other columns are preserved. When .data is supplied, face , c , and the date arguments must come from its columns. |
| `face` | `NULL` | Positive face value of the bond. Numeric scalar or vector in direct-input mode; otherwise the corresponding column of .data . |
| `c` | `NULL` | Nonnegative annual nominal coupon rate, as a proportion (0.06 for 6 percent). Numeric scalar or vector. |
| `settlement` | `NULL` | Date of settlement. The accrued-interest convention excludes this date from the elapsed interval. |
| `previous_coupon` | `NULL` | Date of the immediately preceding coupon date. |
| `next_coupon` | `NULL` | Date of the immediately following coupon date. Settlement must satisfy previous_coupon <= settlement < next_coupon . At a coupon date, supply that date as previous_coupon to obtain zero accrued interest. |
| `k` | `1L` | Number of regular coupon payments per year, a positive integer; defaults to 1. For data-frame input, the k column, if present, takes precedence over this argument. |
| `day_count` | `"act/act"` | Day-count convention, one of "act/act" , "act/360" , "act/365" , or "30e/360" . The default is "act/act" , defined as actual days divided by actual days in the coupon period, with annual coupon fraction 1/k . For data-frame input, a day_count column, if present, takes precedence over this argument. "30e/360" denotes the European 30E/360 convention with both day-of-month values capped at 30. |
| `clean_price` | `NULL` | Optional quoted clean price, in the same currency units and for the same face value as face . |
| `dirty_price` | `NULL` | Optional dirty price, on the same basis. If either price is provided, the other is determined by the clean/dirty price identity. If both are supplied, their consistency is checked. |
| `tol` | `1e-10` | Positive scalar tolerance for reconciling prices when both are supplied; finite and used as a scaled absolute tolerance. The bound is tol * max(1, abs(clean_price), abs(dirty_price), abs(accrued_interest)) for each row. The unit floor is part of this price-reconciliation rule; it is not a yield-solver tolerance. |

## B04 — bond_book_value

Documentación: `man/bond_book_value.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face or par value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Final maturity in years. |
| `t` | `<obligatorio>` | Numeric vector. Valuation time(s) in years, measured from issue. Each value must lie between 0 and n and must align with coupon dates. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `y_effective_per_period` | `NULL` | Optional numeric scalar. Effective yield per coupon period. If supplied, it is used directly. |
| `y` | `NULL` | Optional numeric scalar. Annual yield rate value. |
| `y_type` | `"effective"` | Character string indicating the annual yield type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `y_m` | `1L` | Positive integer. Conversion frequency for nominal annual yields. |
| `R` | `NULL` | Numeric scalar. Redemption value at final maturity. If NULL , defaults to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Absolute tolerance for alignment of n * k and t * k with integer periods, not a monetary tolerance. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs input validation. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric vector of book values. If TRUE , returns a tibble with intermediate quantities. |

## B04 — bond_callable_price

Documentación: `man/bond_callable_price.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face or par value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Final maturity in years. Must be strictly positive. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `call_t` | `<obligatorio>` | Numeric vector of callable times in years. Each value must be strictly between 0 and n , and must align with coupon dates. |
| `call_R` | `<obligatorio>` | Numeric vector of call prices corresponding to call_t . |
| `y_effective_per_period` | `NULL` | Optional numeric scalar. Effective yield per coupon period. If supplied, it is used directly. |
| `y` | `NULL` | Optional numeric scalar. Annual yield rate value. |
| `y_type` | `"effective"` | Character string indicating the annual yield type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `y_m` | `1L` | Positive integer. Conversion frequency for nominal annual yields. |
| `R` | `NULL` | Numeric scalar. Redemption value at final maturity. If NULL , defaults to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Absolute tolerance for alignment of n * k and call_t * k with integer periods. It is not a monetary tolerance and does not define ties between scenario prices. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs input validation. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns the worst-case callable-bond price. If TRUE , returns a tibble with all redemption scenarios. |

## B04 — bond_cash_flows

Documentación: `man/bond_cash_flows.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate. |
| `n` | `<obligatorio>` | Numeric scalar. Years to maturity. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `R` | `NULL` | Numeric scalar. Redemption value. If NULL , it is set equal to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Absolute tolerance for integer alignment of k and n * k ; it is not a monetary tolerance. |
| `check` | `TRUE` | Logical scalar. Input validation. |

## B04 — bond_convexity

Documentación: `man/bond_convexity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Time to maturity in years. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `y_effective_per_period` | `NULL` | Optional numeric scalar. Effective yield per coupon period. |
| `y` | `NULL` | Optional numeric scalar. Annual yield rate value. |
| `y_type` | `"effective"` | Character string indicating the annual yield type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `y_m` | `1L` | Positive integer. Conversion frequency for nominal annual yields. |
| `R` | `NULL` | Numeric scalar. Redemption value at maturity. If NULL , defaults to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Tolerance used to check maturity alignment with integer coupon periods, not a monetary price threshold. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs input validation. |

## B04 — bond_duration

Documentación: `man/bond_duration.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Time to maturity in years. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `y_effective_per_period` | `NULL` | Optional numeric scalar. Effective yield per coupon period. |
| `y` | `NULL` | Optional numeric scalar. Annual yield rate value. |
| `y_type` | `"effective"` | Character string indicating the annual yield type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `y_m` | `1L` | Positive integer. Conversion frequency for nominal annual yields. |
| `R` | `NULL` | Numeric scalar. Redemption value at maturity. If NULL , defaults to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Tolerance used to check maturity alignment with integer coupon periods, not a monetary price threshold. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs input validation. |

## B04 — bond_price

Documentación: `man/bond_price.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `face` | `<obligatorio>` | Numeric scalar. Face value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Time to maturity in years. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `y_effective_per_period` | `NULL` | Optional numeric scalar. Effective yield per coupon period. If supplied, it is used directly. |
| `y` | `NULL` | Optional numeric scalar. Annual yield rate value. |
| `y_type` | `"effective"` | Character string indicating the annual yield type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `y_m` | `1L` | Positive integer. Conversion frequency for nominal annual yields. |
| `R` | `NULL` | Numeric scalar. Redemption value at maturity. If NULL , defaults to face . |
| `tol` | `1e-10` | Finite positive numeric scalar. Tolerance used when checking alignment of maturity with coupon periods. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs basic input validation. |

## B04 — bond_ytm

Documentación: `man/bond_ytm.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `P` | `<obligatorio>` | Numeric scalar. Observed dirty price of the bond at time 0. |
| `face` | `<obligatorio>` | Numeric scalar. Face value of the bond. |
| `c` | `<obligatorio>` | Numeric scalar. Annual coupon rate as a proportion. |
| `n` | `<obligatorio>` | Numeric scalar. Time to maturity in years. Must be strictly positive. |
| `k` | `1L` | Positive integer. Number of coupon payments per year. |
| `R` | `NULL` | Numeric scalar. Redemption value at maturity. If NULL , defaults to face . |
| `interval` | `NULL` | Optional finite numeric vector of length 2 giving an increasing bracket for the effective yield per coupon period, with both bounds above -1. |
| `tol` | `1e-12` | Finite positive numeric scalar. Yield-coordinate tolerance passed to uniroot , not a monetary price tolerance. |
| `maxiter` | `1000` | Positive integer. Maximum number of iterations passed to uniroot . |
| `check` | `TRUE` | Logical scalar. If TRUE , performs basic input checks. |

## B04 — bootstrap_spot_curve

Documentación: `man/bootstrap_spot_curve.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `<obligatorio>` | Nonempty data frame with one row per priced instrument. |
| `col_instrument` | `"instrument"` | Character scalar naming the unique instrument-ID column. |
| `col_price` | `"price"` | Character scalar naming the observed dirty-price column. |
| `col_t` | `"t"` | Character scalar naming the list-column of positive payment times in years. |
| `col_cf` | `"cf"` | Character scalar naming the list-column of nonnegative cash flows corresponding to col_t . |

## B04 — convexity_cash_flow

Documentación: `man/convexity_cash_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash-flow amounts. |
| `t` | `<obligatorio>` | Numeric vector of cash-flow times. Times must be expressed in the same units used by `rate`. |
| `rate` | `<obligatorio>` | Effective yield per unit of time. It must be a finite numeric scalar greater than `-1`. |
| `valuation_time` | `0` | Finite numeric scalar indicating the valuation time. Defaults to `0`. |
| `output` | `c("value", "audit")` | Character scalar indicating the returned object: `"value"` returns convexity as a numeric scalar; `"audit"` returns a detailed tibble. |

## B04 — duration_cash_flow

Documentación: `man/duration_cash_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `cf` | `<obligatorio>` | Numeric vector of cash-flow amounts. |
| `t` | `<obligatorio>` | Numeric vector of cash-flow times. Times must be expressed in the same units used by `rate`. |
| `rate` | `<obligatorio>` | Effective yield per unit of time. It must be a finite numeric scalar greater than `-1`. |
| `valuation_time` | `0` | Finite numeric scalar indicating the valuation time. Defaults to `0`. |
| `duration` | `c("macaulay", "modified")` | Character scalar indicating the duration measure: `"macaulay"` or `"modified"`. |
| `output` | `c("value", "audit")` | Character scalar indicating the returned object: `"value"` returns the selected duration as a numeric scalar; `"audit"` returns a detailed tibble. |

## B04 — forward_curve

Documentación: `man/forward_curve.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | Optional data frame or tibble containing spot maturities and rates, in numeric columns or corresponding list-columns. |
| `t` | `NULL` | Numeric vector of maturities in years if .data = NULL . |
| `i` | `NULL` | Numeric vector of spot rates if .data = NULL . |
| `col_t` | `"t"` | Name of the maturity column in .data . |
| `col_i` | `"i"` | Name of the spot-rate column in .data . |
| `col_curve` | `NULL` | Optional name of a curve-identifier column in .data . Required to distinguish multiple curves stored as numeric node rows; optional for list-column input. |
| `i_type` | `"effective"` | Spot-rate convention: "effective" , "nominal_interest" , "nominal_discount" or "force" . Scalar for multiple curves, or scalar/nodewise for a single curve. |
| `m` | `1L` | Conversion frequency for nominal rates. A positive integer; scalar for multiple curves, or scalar/nodewise for one curve. |
| `include_origin` | `TRUE` | Logical scalar. If TRUE (default), include the initial interval from time zero when the first observed node is positive. |

## B04 — forward_rate

Documentación: `man/forward_rate.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data.frame or tibble. If NULL , t , i , t_start , and t_end must be supplied. |
| `t` | `NULL` | Numeric vector of maturities in years when .data = NULL . |
| `i` | `NULL` | Numeric vector of spot-rate values when .data = NULL . |
| `t_start` | `NULL` | Numeric scalar giving the start maturity when .data = NULL . |
| `t_end` | `NULL` | Numeric scalar giving the end maturity when .data = NULL . |
| `col_t` | `"t"` | Name of the list-column containing maturities. |
| `col_i` | `"i"` | Name of the list-column containing spot rates. |
| `col_t_start` | `"t_start"` | Name of the numeric column containing the start maturity. |
| `col_t_end` | `"t_end"` | Name of the numeric column containing the end maturity. |
| `i_type` | `"effective"` | Character vector indicating the spot-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . May have length 1 or the same length as each curve. |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal spot rates. May have length 1 or the same length as each curve. |
| `method` | `c("exact", "linear")` | Spot extraction method: "exact" or "linear" . |
| `plot` | `FALSE` | Logical; if TRUE , adds a list-column of ggplot2 objects. |
| `.out` | `"f"` | Name of the output column containing the forward rate. |
| `.out_plot` | `"forward_rate_plot"` | Name of the output list-column containing ggplot2 objects. Used only if plot = TRUE . |
| `.keep` | `c("all", "used", "none")` | One of "all" , "used" , or "none" . |
| `.na` | `c("propagate", "error", "drop")` | NA handling policy: "propagate" , "error" , or "drop" . |

## B04 — immunize_duration

Documentación: `man/immunize_duration.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `L` | `<obligatorio>` | Numeric vector with liability payments. |
| `t` | `<obligatorio>` | Numeric vector of the same length as L , giving the times at which each liability payment occurs. |
| `P` | `<obligatorio>` | Numeric vector with present values or prices of the immunizing assets, evaluated on the same yield basis. |
| `D` | `<obligatorio>` | Numeric vector with the Macaulay duration of each asset, expressed in the same time units as t . |
| `i` | `<obligatorio>` | Numeric scalar. Interest-rate input used to discount the liabilities. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |

## B04 — immunize_duration_convexity

Documentación: `man/immunize_duration_convexity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `L` | `<obligatorio>` | Numeric vector with liability payments. |
| `t` | `<obligatorio>` | Numeric vector of the same length as L , giving the times at which each liability payment occurs. |
| `P` | `<obligatorio>` | Numeric vector with present values or prices of the immunizing assets, evaluated on the same yield basis. |
| `D` | `<obligatorio>` | Numeric vector with the Macaulay duration of each asset, expressed in the same time units as t . |
| `C` | `<obligatorio>` | Numeric vector with each asset's relative second derivative P_j''(i_e)/P_j(i_e) with respect to the annual effective yield i_e , using the same time units as t . A coupon-period convexity divided by squared coupon frequency generally uses a different yield variable and must be converted before use here. |
| `i` | `<obligatorio>` | Numeric scalar. Interest-rate input used to discount the liabilities. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |

## B04 — par_rate

Documentación: `man/par_rate.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | Optional data frame containing a spot curve as numeric columns, or multiple curves as list-columns. For pipe-friendly usage. |
| `t` | `NULL` | Numeric vector of curve maturities (years) when .data = NULL . |
| `i` | `NULL` | Numeric vector of observed spot rates when .data = NULL . |
| `n` | `NULL` | Bond maturity in years. Defaults to the maximum maturity of each curve; may also be a scalar or one value per curve. |
| `face` | `100` | Strictly positive face value; scalar or one value per curve. |
| `k` | `1L` | Positive integer coupon frequency per year; scalar or one value per curve. Coupon dates are seq_len(n * k) / k . |
| `R` | `NULL` | Redemption amount, scalar or one value per curve; defaults to face . |
| `i_type` | `"effective"` | Spot rate type ( "effective" , "nominal_interest" , "nominal_discount" , or "force" ). Passed to discount_factor_spot() . Must have length one or one value per curve node. |
| `m` | `1L` | Conversion frequency for nominal spot rates, passed to discount_factor_spot() . Must have length one or one per curve node. |
| `col_t` | `"t"` | Name of the spot maturity column in .data . |
| `col_i` | `"i"` | Name of the spot rate column in .data . |
| `tol` | `1e-10` | Positive numerical tolerance for aligning coupon dates and curve maturities. Does not authorize interpolation. |

## B04 — plot_immunization_gap

Documentación: `man/plot_immunization_gap.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `L` | `<obligatorio>` | Numeric vector of liability payments. |
| `t` | `<obligatorio>` | Numeric vector of times of each liability payment. |
| `asset_cashflows` | `<obligatorio>` | A list where each element is a list with components $cf and $t , defining each asset's cash flow. |
| `w` | `<obligatorio>` | Numeric vector of portfolio weights or units. Must have the same length as asset_cashflows . |
| `i` | `<obligatorio>` | Base interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `delta` | `0.01` | A numeric value defining the range of annual effective rates: from i_effective - delta to i_effective + delta , where i_effective is the annual effective rate equivalent to i , i_type , and m . |
| `n_grid` | `200L` | Number of rate values to evaluate. Integer from 2 through .Machine$integer.max , with sufficient memory for the requested grid. |

## B04 — portfolio_convexity

Documentación: `man/portfolio_convexity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data.frame or tibble. If NULL , P and C must be supplied as vectors. |
| `portfolio_id` | `NULL` | Optional vector of portfolio identifiers when .data = NULL . If omitted, all positions are treated as belonging to a single portfolio. |
| `P` | `NULL` | Numeric vector of present values, prices, or market values when .data = NULL . |
| `C` | `NULL` | Numeric vector of individual convexities when .data = NULL . |
| `col_portfolio` | `"portfolio_id"` | Name of the portfolio identifier column. If NULL , all rows are treated as one portfolio. |
| `col_P` | `"P"` | Name of the numeric column containing present values, prices, or market values. |
| `col_C` | `"C"` | Name of the numeric column containing individual convexities. |
| `.out` | `"C_P"` | Name of the output column containing portfolio convexity. |
| `.out_value` | `"P_total"` | Name of the output column containing total portfolio value. |
| `.out_n` | `"n_positions"` | Name of the output column containing the number of positions used in the calculation. |
| `.na` | `c("propagate", "error", "drop")` | NA handling policy: "propagate" , "error" , or "drop" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using market_value , convexity , col_market_value , and col_convexity . These names are mapped to P , C , col_P , and col_C . |

## B04 — portfolio_duration

Documentación: `man/portfolio_duration.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data.frame or tibble. If NULL , P and D must be supplied as vectors. |
| `portfolio_id` | `NULL` | Optional vector of portfolio identifiers when .data = NULL . If omitted, all positions are treated as belonging to a single portfolio. |
| `P` | `NULL` | Numeric vector of present values, prices, or market values when .data = NULL . |
| `D` | `NULL` | Numeric vector of individual durations when .data = NULL . |
| `col_portfolio` | `"portfolio_id"` | Name of the portfolio identifier column. If NULL , all rows are treated as one portfolio. |
| `col_P` | `"P"` | Name of the numeric column containing present values, prices, or market values. |
| `col_D` | `"D"` | Name of the numeric column containing individual durations. |
| `.out` | `"D_P"` | Name of the output column containing portfolio duration. |
| `.out_value` | `"P_total"` | Name of the output column containing total portfolio value. |
| `.out_n` | `"n_positions"` | Name of the output column containing the number of positions used in the calculation. |
| `.na` | `c("propagate", "error", "drop")` | NA handling policy: "propagate" , "error" , or "drop" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using market_value , duration , col_market_value , and col_duration . These names are mapped to P , D , col_P , and col_D . |

## B04 — yield_curve

Documentación: `man/yield_curve.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble. If NULL , t and i must be supplied as numeric vectors. |
| `t` | `NULL` | Numeric vector of maturities in years when .data = NULL . |
| `i` | `NULL` | Numeric vector of spot-rate values when .data = NULL . |
| `col_t` | `"t"` | Name of the list-column containing maturities. |
| `col_i` | `"i"` | Name of the list-column containing spot rates. |
| `i_type` | `"effective"` | Character vector indicating the spot-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . May have length 1 or the same length as each curve. |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal spot rates. May have length 1 or the same length as each curve. |
| `plot` | `FALSE` | Logical. If TRUE , adds a list-column of ggplot2 objects. |
| `.out` | `"v"` | Name of the output list-column containing discount factors. |
| `.out_plot` | `"yield_curve_plot"` | Name of the output list-column containing ggplot2 objects. Used only if plot = TRUE . |
| `.keep` | `c("all", "used", "none")` | One of "all" , "used" , or "none" . |
| `.na` | `c("propagate", "error", "drop")` | Missing-value handling policy: "propagate" , "error" , or "drop" . |

## B05 — commutation_table

Documentación: `man/commutation_table.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table object as produced by lifetable . It must contain columns x and lx . If available, qx or px may also be present, but dx is computed robustly from successive values of lx . |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `check` | `TRUE` | Logical. If TRUE , performs basic input checks. |

## B05 — e_x

Documentación: `man/e_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table object as produced by lifetable (must contain columns x and lx ). |
| `x` | `<obligatorio>` | Integer age(s). |
| `t` | `NULL` | Optional nonnegative numeric duration(s). If NULL (default), the whole-life expectancy is computed (i.e., horizon extends to \omega - x ). If a numeric value is provided, the t -year temporary life expectancy is returned. |
| `type` | `c("curtate", "complete")` | Character: "curtate" (default) or "complete" . |
| `frac` | `<obligatorio>` | Fractional-age assumption for type = "complete" : "UDD" , "CF" , "CML" (alias of CF), or "Balducci" . If not specified and lt carries a frac attribute (set by lifetable ), that value is used. |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble. |
| `check` | `TRUE` | Logical. If TRUE , performs basic input checks. |
| `tol` | `1e-10` | Numeric tolerance for integer checks. |

## B05 — km_lifetable

Documentación: `man/km_lifetable.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `time` | `<obligatorio>` | Numeric vector. Observed times (event or censoring times). |
| `status` | `<obligatorio>` | Integer/numeric vector of the same length as time . Use 1 for event (death), 0 for right-censoring. |
| `entry` | `NULL` | Optional numeric vector of entry times (left truncation / delayed entry). If provided, must have the same length as time and satisfy entry <= time . If NULL , all individuals are assumed to enter at time 0. |
| `breaks` | `NULL` | Optional numeric vector of increasing cut points used to build the discrete life table (e.g., 0:omega ). If NULL , defaults to integer ages from 0 to ceiling(max(time)) . |
| `radix` | `1e+05` | Numeric. Life table radix used to scale \ell_x (default 1e5 ). |
| `conf_level` | `0.95` | Numeric in (0,1) . Confidence level for pointwise intervals for \hat S(t) computed via the log(-log) transformation (default 0.95 ). |
| `assumption` | `c("UDD", "CF", "Balducci")` | Character. Fractional-age assumption used to compute L_x within each interval: "UDD" , "CF" (constant force), or "Balducci" . |

## B05 — lifetable

Documentación: `man/lifetable.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | Numeric vector of ages. Must be **integer** and **consecutive** (annual table), e.g. 0:110 . |
| `lx` | `NULL` | Optional numeric vector of survivors \ell_x . Must be nonnegative and nonincreasing. |
| `qx` | `NULL` | Optional numeric vector of one-year death probabilities q_x . NA values are allowed (useful at the last age when close=TRUE ), but Inf / NaN are not allowed. |
| `px` | `NULL` | Optional numeric vector of one-year survival probabilities p_x . NA values are allowed, but Inf / NaN are not allowed. If provided, qx = 1 - px . |
| `mx` | `NULL` | Optional numeric vector of central death rates m_x . NA values are allowed, but Inf / NaN are not allowed. If provided, converted to qx using ax . |
| `radix` | `NULL` | Optional positive scalar. Required if building lx from ( qx / px / mx ) and lx is not provided. |
| `omega` | `NULL` | Optional integer limiting age. If omega < max(x) , the table is truncated to omega . If omega > max(x) , an error is raised (the function will not invent missing ages). |
| `close` | `TRUE` | Logical. If TRUE (default), closes the table at omega (forces terminal conditions). With FALSE and only lx , the last dx/qx/px/mx are unknown ( NA ); a supplied terminal probability is used when available. |
| `ax` | `0.5` | Scalar in [0,1] . Average fraction of the year lived by those who die in the interval [x, x+1) . Under UDD (Finan, Sec. 24.1), ax = 0.5 . Under constant force, a_x = 1/\mu - 1/(\exp(\mu)-1) . At the terminal age with close = TRUE , mx equals 1/a_x , which is 2 for ax = 0.5 , 1 for ax = 1 , and Inf for ax = 0 . Default is 0.5 . |
| `type` | `c("ultimate", "select")` | Character. "ultimate" or "select" (metadata). Stored as an attribute and used by downstream functions. |
| `frac` | `c("UDD", "CF", "Balducci")` | Character. "UDD" , "CF" , or "Balducci" (metadata). Stored as an attribute and used by fractional-age functions such as t_px . |
| `check` | `TRUE` | Logical. If TRUE (default), performs strict validity and consistency checks, including px = 1 - qx when both are provided. Validated ages within tolerance of integers are rounded before truncation. |
| `tol` | `1e-10` | Numeric tolerance for integer checks and consistency checks. |

## B05 — lt_tau

Documentación: `man/lt_tau.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `md` | `<obligatorio>` | A multiple decrement table (typically the output of md_table ), containing columns x and q_total . |
| `...` | `<argumentos adicionales; sin default>` | Additional arguments passed to lifetable (e.g., radix , omega , close , ax , type , frac , check , tol ). |

## B05 — md_table

Documentación: `man/md_table.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `qx_df` | `<obligatorio>` | A data.frame/tibble with an age column (default x ) and one or more cause columns containing annual probabilities in [0,1] . Recommended naming convention: cause columns start with "q_" (e.g., q_death , q_disability ). |
| `age_col` | `"x"` | Character. Name of the age column (default "x" ). |
| `cause_cols` | `NULL` | Character vector. Names of the cause columns. If NULL (default), all columns other than age_col are treated as causes. Cause names must not collide with reserved totals or generated death columns. |
| `radix` | `1e+05` | Numeric. Starting cohort size at the first age (default 1e5 ). |
| `close` | `TRUE` | Logical. If TRUE , requires q_{\omega}^{(\tau)} = 1 at the last age (default TRUE ). |
| `check` | `TRUE` | Logical. If TRUE , performs input validation (default TRUE ). |
| `tol` | `1e-10` | Numeric tolerance used in checks (default 1e-10 ). |

## B05 — mortality_law_table

Documentación: `man/mortality_law_table.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `law` | `c("Exponential", "Gompertz", "Makeham", "Weibull", "Logistic", "DeMoivre", "Beta", "HeligmanPollard")` | Character. Mortality law. One of "Exponential" , "Gompertz" , "Makeham" , "Weibull" , "Logistic" , "DeMoivre" , "Beta" , or "HeligmanPollard" . |
| `x_min` | `<obligatorio>` | Integer. Minimum age, inclusive. |
| `x_max` | `<obligatorio>` | Integer. Maximum age, inclusive. Must satisfy x_min < x_max . |
| `...` | `<argumentos adicionales; sin default>` | Named law parameters. These values override params . Placing ... before arguments such as close and check avoids partial-matching conflicts with the Gompertz and Makeham parameter c . |
| `params` | `NULL` | Named list of law parameters, or NULL . |
| `frac` | `c("CF", "UDD", "Balducci", "CML")` | Character. Within-year interpolation label, independent of the annual probability calculation. One of "CF" , "UDD" , "Balducci" , or "CML" . "CML" is treated as "CF" . |
| `l0` | `1e+05` | Numeric scalar. Initial radix, that is, the starting value l_{x_min} . |
| `close` | `TRUE` | Logical. If TRUE , forces the last age to close. |
| `a_x` | `0.5` | Numeric scalar. Average fraction of the year lived by those dying between age x and x+1 . Default is 0.5 . Exposure uses L_x = l_{x+1} + a_x d_x ; this is an approximation controlled by a_x , not an integration of continuous survival. |
| `check` | `TRUE` | Logical. If TRUE , performs strict input validation. |
| `tol` | `1e-10` | Numeric tolerance used in checks. |
| `radix` | `NULL` | Deprecated. Use l0 . |
| `ax` | `NULL` | Deprecated. Use a_x . |

## B05 — plot_km

Documentación: `man/plot_km.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `km` | `<obligatorio>` | A data frame or tibble with at least columns for time and survival. Can also be the full list returned by km_lifetable , in which case the $km component is extracted automatically. |
| `time_col` | `"time"` | Character. Name of the time column. Default "time" . |
| `surv_col` | `"S"` | Character. Name of the survival column. Default "S" (matching km_lifetable output). |
| `lower_col` | `"ci_low"` | Character. Name of the lower CI column. Default "ci_low" (matching km_lifetable output). |
| `upper_col` | `"ci_high"` | Character. Name of the upper CI column. Default "ci_high" (matching km_lifetable output). |
| `conf_int` | `TRUE` | Logical. If TRUE (default) and CI columns exist in km , plot a step-wise confidence ribbon. |
| `title` | `NULL` | Optional character string for the plot title. |

## B05 — t_Ex

Documentación: `man/t_Ex.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A lifetable object as produced by lifetable . Must contain columns x and lx . |
| `x` | `<obligatorio>` | Integer age(s) at which the endowment starts. |
| `t` | `<obligatorio>` | Nonnegative numeric duration(s) in years. Fractional durations are allowed and are handled through t_px . |
| `i` | `<obligatorio>` | Annual interest-rate input(s). |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `frac` | `<obligatorio>` | Fractional-age assumption passed to t_px : "UDD" , "CF" , "CML" (alias of CF), or "Balducci" . If not specified and lt carries a frac attribute, that value is used. |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with columns x , t , i , i_type , m , i_effective , frac , and nEx . |
| `check` | `TRUE` | Logical. If TRUE , performs validity checks. |
| `tol` | `1e-10` | Numeric tolerance for integer checks on x . |

## B05 — t_px

Documentación: `man/t_px.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A lifetable object as produced by lifetable . Must contain columns x and lx . Columns qx or px are used if present. |
| `x` | `<obligatorio>` | Integer age(s) at which survival starts. |
| `t` | `<obligatorio>` | Nonnegative numeric duration(s) in years (can be fractional). |
| `frac` | `<obligatorio>` | Fractional-age assumption: "UDD" , "CF" , "CML" (alias of CF), or "Balducci" . If not specified and lt carries a frac attribute (set by lifetable ), that value is used. |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with columns x , t , frac , tpx . |
| `check` | `TRUE` | Logical. If TRUE , performs validity checks. |
| `tol` | `1e-10` | Numeric tolerance for integer checks on x . |

## B05 — t_qx

Documentación: `man/t_qx.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A lifetable object as produced by lifetable . Must contain columns x and lx . Columns qx or px are used if present. |
| `x` | `<obligatorio>` | Integer age(s) at which the interval starts. |
| `t` | `<obligatorio>` | Nonnegative numeric duration(s) in years (can be fractional). |
| `frac` | `<obligatorio>` | Fractional-age assumption: "UDD" , "CF" , "CML" (alias of CF), or "Balducci" . If not specified and lt carries a frac attribute (set by lifetable ), that value is used. Passed directly to t_px . |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with columns x , t , frac , tqx . |
| `check` | `TRUE` | Logical. If TRUE , performs validity checks. |
| `tol` | `1e-10` | Numeric tolerance for integer checks on x . |

## B05 — t_qxj

Documentación: `man/t_qxj.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `md` | `<obligatorio>` | A multiple decrement table produced by md_table . Must contain columns x , p_total , and the requested cause . |
| `x` | `<obligatorio>` | Numeric vector. Starting age(s) (integer-valued). |
| `t` | `<obligatorio>` | Numeric vector. Time horizon(s) in years (t >= 0). Can be non-integer if frac is supplied. |
| `cause` | `<obligatorio>` | Character. Name of the cause column in md (e.g., "q_death" ). |
| `frac` | `NULL` | Character. Fractional-age assumption for non-integer t : one of "UDD" , "CF" , "Balducci" , or NULL . If NULL (default), t must be integer-valued. |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with columns x , t , cause , frac , and tqxj . |
| `check` | `TRUE` | Logical. If TRUE , performs input validation (default TRUE ). |
| `tol` | `1e-10` | Numeric tolerance for integer checks (default 1e-10 ). |

## B06 — A_xj (alias de insurance_xj)

Documentación: `man/insurance_xj.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `md` | `<obligatorio>` | A multiple decrement table produced by md_table . Must contain columns x , p_total , and the requested cause . |
| `x` | `<obligatorio>` | Integer age(s) at issue. |
| `i` | `<obligatorio>` | Finite annual interest-rate input in the valid domain of its original rate specification. Extreme annual equivalents may round to -1 or overflow, while the original log accumulation remains usable. |
| `cause` | `<obligatorio>` | Character scalar. Name of the cause column in md , for example "q_death" . |
| `type` | `c("whole", "term")` | Character scalar. Insurance type: "whole" or "term" . |
| `benefit` | `1` | Numeric benefit amount payable at the end of the year of decrement by the specified cause. Default is 1 . |
| `n` | `NULL` | Integer term length in years. Required when type = "term" . |
| `h` | `0L` | Integer deferment period in years. Default is 0 . |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with inputs and insurance_xj . |
| `check` | `TRUE` | Logical. If TRUE , performs input validation. |
| `tol` | `1e-10` | Numeric tolerance for integer checks. |

## B06 — add_insurance

Documentación: `man/add_insurance.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `contract` | `<obligatorio>` | A `tidyact_life_contract` object. |
| `type` | `c("whole", "term", "endowment", "pure_endowment", "variable_k")` | Insurance type. Single-life contracts support `"whole"`, `"term"`, `"endowment"`, and `"variable_k"`. Two-life contracts support `"whole"`, `"term"`, `"endowment"`, and `"pure_endowment"`. |
| `benefit` | `1` | Benefit amount. For standard products, a single nonnegative numeric value. For single-life `type = "variable_k"`, a numeric vector or a function of time may be supplied. |
| `n` | `Inf` | Insurance term in years. Use `Inf` for whole-life insurance. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `k` | `1L` | Positive integer. Benefit frequency for single-life `type = "variable_k"`. |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption: `"UDD"`, `"CF"`, `"CML"`, or `"Balducci"`. |

## B06 — add_premium_schedule

Documentación: `man/add_premium_schedule.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `contract` | `<obligatorio>` | A `tidyact_life_contract` object. |
| `k` | `1L` | Positive integer. Number of premium payments per year. |
| `timing` | `c("due", "immediate")` | Timing of premium payments: `"due"` or `"immediate"`. |
| `premium_start` | `c("issue", "deferred")` | Start of premium payments: `"issue"` or `"deferred"`. |
| `n_prem` | `NULL` | Premium-paying term in years. Use `NULL` to infer the term from the insurance component. A fractional value is allowed when `n_prem * k` is an integer. |
| `woolhouse` | `c("none", "first", "second")` | Woolhouse approximation order: `"none"`, `"first"`, or `"second"`. |
| `frac` | `NULL` | Fractional-age assumption. If `NULL`, the insurance component's assumption is used when available; otherwise `"UDD"`. |

## B06 — annuity_multi

Documentación: `man/annuity_multi.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table object (data frame or tibble) with column x and at least one of lx , px , or qx . For different mortality assumptions by life, pass a list of life tables of the same length as ages , for example list(lt_male, lt_female) . |
| `ages` | `<obligatorio>` | Integer vector of actuarial ages for the lives at issue. Must have length 1, 2, or 3. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . In tidyactuarial , m is reserved for interest conversion frequency, not deferment. |
| `n` | `NULL` | Integer term in years after deferment. If NULL , runs to the end of the available table horizon, conservatively based on the smallest omega across life tables. |
| `h` | `0L` | Integer deferment period in years. |
| `k` | `1L` | Integer payments per year. If k > 1 , Woolhouse approximations may be applied. |
| `annuity` | `c("cohort", "reversionary")` | Type of annuity logic: "cohort" uses the status defined in cohort ; "reversionary" uses the \alpha fractional reduction. |
| `cohort` | `c("first", "last")` | Survival status: "first" for joint-life, paying while all lives are alive, or "last" for last-survivor, paying while at least one life remains alive. Used only when annuity = "cohort" . |
| `alpha` | `NULL` | Reversionary fraction, typically 0 \le \alpha \le 1 . Used only when annuity = "reversionary" . Note: alpha = 0 matches joint-life; alpha = 1 matches last-survivor. |
| `timing` | `c("immediate", "due")` | "immediate" or "due" . |
| `woolhouse` | `c("none", "first", "second")` | "none" , "first" , or "second" . |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption for exact payments: "UDD" (default), "CF" , "CML" (alias of CF), or "Balducci" . |

## B06 — annuity_x

Documentación: `man/annuity_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table as produced by lifetable , or a tidyact_life_contract object created by life_contract . A life table must contain columns x and lx . |
| `x` | `<obligatorio>` | Integer actuarial age, or a vector of scenario ages. Optional when lt is a single-life tidyact_life_contract . |
| `i` | `<obligatorio>` | Numeric annual interest-rate input, scalar or by scenario. Optional when lt is a single-life tidyact_life_contract . |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal interest rates. Ignored for i_type = "effective" and i_type = "force" . In tidyactuarial , m is reserved for interest conversion frequency, not deferment. |
| `n` | `NULL` | Numeric term in years. Use NULL or Inf for a whole-life annuity. For exact k-thly valuation ( woolhouse = "none" ), fractional terms are allowed when n * k is an integer. Woolhouse approximations require an integer number of years. |
| `h` | `0L` | Integer deferment period in years. |
| `k` | `1L` | Positive integer. Number of annuity payments per year. For example, use k = 12 for monthly payments. The annuity is normalized to an annual payment rate of 1, so each individual payment has amount 1 / k . |
| `timing` | `c("immediate", "due")` | Character string. Either "immediate" for payments at the end of each payment period or "due" for payments at the beginning of each payment period. |
| `woolhouse` | `c("none", "first", "second")` | Character string. For k > 1 , use "none" for exact fractional-age computation, "first" for the first-order Woolhouse approximation, or "second" for the second-order Woolhouse approximation. |
| `frac` | `NULL` | Character string. Fractional-age assumption used when k > 1 and woolhouse = "none" . Allowed values are "UDD" , "CF" , "CML" , and "Balducci" . If NULL , the frac attribute of lt is used when available; otherwise "UDD" is used. |
| `tidy` | `FALSE` | Logical. If FALSE , returns a numeric APV. If TRUE , returns one tibble row per scenario with intermediate quantities. |

## B06 — apv_life_flow

Documentación: `man/apv_life_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table data frame with column x and at least one of lx , px , or qx . |
| `ages` | `<obligatorio>` | Integer vector of actuarial ages. Use length 1 for a single life and length 2 or more for multiple lives. |
| `t` | `NULL` | Numeric vector of payment times in years, measured from time 0. Provide either t or date . |
| `date` | `NULL` | Optional vector of Date payment dates. Provide either t or date . |
| `date0` | `NULL` | Optional Date used as time 0 when date is provided. If missing, the minimum of date is used. |
| `cf` | `<obligatorio>` | Numeric vector of cash flows. Must have the same length as t or date . |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `status` | `c("single", "first", "last", "reversionary")` | Survival status: "single" , "first" , "last" , or "reversionary" . |
| `alpha` | `NULL` | Reversionary fraction for status = "reversionary" . While all lives are alive, full benefit is paid; while at least one but not all are alive, alpha times the benefit is paid. |
| `plot` | `FALSE` | Logical. If TRUE , attaches a ggplot object in attr(result, "plot") showing cumulative APV over time. |

## B06 — insurance_variable_k

Documentación: `man/insurance_variable_k.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table object or data frame containing at least columns x and lx . |
| `x` | `<obligatorio>` | Integer actuarial age at issue. |
| `i` | `<obligatorio>` | Annual interest-rate input. |
| `benefit` | `<obligatorio>` | Numeric vector of benefits by subperiod, or a function of time returning the benefit at time t . |
| `n` | `NULL` | Optional term in years. If NULL , the term is inferred from the length of benefit when benefit is numeric. If benefit is a function, n must be supplied. |
| `h` | `0` | Nonnegative deferment period in years. Default is 0 . |
| `k` | `12` | Positive integer. Number of subperiods per year. Default is 12 . |
| `i_type` | `"effective"` | Character scalar indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer scalar giving the conversion frequency for nominal interest-rate inputs. Ignored for "effective" and "force" . |
| `frac` | `<obligatorio>` | Fractional-age assumption used in survival probabilities: "UDD" , "CF" , "CML" , or "Balducci" . If not specified and lt carries a frac attribute, that value is used. |
| `tidy` | `FALSE` | Logical. If TRUE , returns a one-row tibble. |
| `check` | `TRUE` | Logical. If TRUE , performs basic input checks. |
| `tol` | `1e-10` | Numeric tolerance used for integer-grid checks. |

## B06 — insurance_x

Documentación: `man/insurance_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table as produced by lifetable . It must contain columns x and lx . |
| `x` | `<obligatorio>` | Integer actuarial age at issue, or a vector of scenario ages. |
| `i` | `<obligatorio>` | Numeric annual interest-rate input, scalar or by scenario. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `n` | `Inf` | Integer insurance term in years. Required for type = "term" and type = "endowment" . Use Inf only for whole-life insurance. |
| `h` | `0L` | Integer deferment period in years. |
| `type` | `c("whole", "term", "endowment")` | Character string. One of "whole" , "term" , or "endowment" . |
| `benefit` | `1` | Numeric benefit amount, scalar or by scenario. A vector represents separate contracts, not a benefit schedule within one contract. |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric APV. If TRUE , returns one tibble row per scenario with intermediate quantities. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age , rate , rate_type , term_years , deferral_years , insurance_type , and output . |

## B06 — insurance_xj

Documentación: `man/insurance_xj.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `md` | `<obligatorio>` | A multiple decrement table produced by md_table . Must contain columns x , p_total , and the requested cause . |
| `x` | `<obligatorio>` | Integer age(s) at issue. |
| `i` | `<obligatorio>` | Finite annual interest-rate input in the valid domain of its original rate specification. Extreme annual equivalents may round to -1 or overflow, while the original log accumulation remains usable. |
| `cause` | `<obligatorio>` | Character scalar. Name of the cause column in md , for example "q_death" . |
| `type` | `c("whole", "term")` | Character scalar. Insurance type: "whole" or "term" . |
| `benefit` | `1` | Numeric benefit amount payable at the end of the year of decrement by the specified cause. Default is 1 . |
| `n` | `NULL` | Integer term length in years. Required when type = "term" . |
| `h` | `0L` | Integer deferment period in years. Default is 0 . |
| `i_type` | `"effective"` | Character vector indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer vector giving the conversion frequency for nominal rates. Ignored for "effective" and "force" . |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble with inputs and insurance_xj . |
| `check` | `TRUE` | Logical. If TRUE , performs input validation. |
| `tol` | `1e-10` | Numeric tolerance for integer checks. |

## B06 — life_contract

Documentación: `man/life_contract.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table or a list of two life tables. For single-life contracts, provide one data frame or tibble. For two-life contracts, provide either one data frame used for both lives, or `list(lt_x, lt_y)` with one table for each life. Each life table must contain columns `x` and `lx`. |
| `lives` | `c("single", "joint", "last_survivor")` | Character string. Use `"single"` for a single-life contract, `"joint"` for a joint-life two-life contract, or `"last_survivor"` for a last-survivor two-life contract. |
| `x` | `NULL` | Numeric scalar. Age of the single life, or age of the first life in a two-life contract. |
| `y` | `NULL` | Numeric scalar. Age of the second life in a two-life contract. Required when `lives` is `"joint"` or `"last_survivor"`. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are `"effective"`, `"nominal_interest"`, `"nominal_discount"`, and `"force"`. |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for `i_type = "effective"` and `i_type = "force"`. |
| `...` | `<argumentos adicionales; sin default>` | Reserved for future extensions. Deprecated argument names such as `mortality_table`, `age`, `age_x`, `age_y`, `rate`, and `rate_type` are not accepted. |

## B06 — plot_contingent_cash_flow

Documentación: `man/plot_contingent_cash_flow.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `<obligatorio>` | A nonempty data frame or tibble. Supply an apv_life_flow() result, or columns t , cf , probability , discount and event . Optional date supplies the horizontal calendar axis. Optional expected_cf and pv are reused after consistency checks. |
| `view` | `c("all", "contractual", "probability", "expected", "pv")` | One of "all" , "contractual" , "probability" , "expected" , or "pv" . The default shows four panels with separate vertical scales. |
| `title` | `NULL` | Optional plot title and subtitle. |
| `subtitle` | `NULL` | Optional plot title and subtitle. |
| `x_label` | `NULL` | Optional horizontal axis label. |
| `show_labels` | `TRUE` | Logical. Show amount/probability labels, omitting text that overlaps at rendering time. All payment rows remain in the plot. |
| `label_size` | `3.2` | Positive text size. |
| `label_digits` | `2L` | Integer between 0 and 50 for monetary labels. |
| `label_format` | `c("auto", "full", "compact")` | Monetary notation: "auto" , "full" , or "compact" , as in plot_cash_flow() . Probabilities/weights use separate unitless labels. |
| `currency` | `""` | Monetary prefix; never applied to probabilities or weights. |
| `col_inflow` | `"#1B9E77"` | Colors for positive and negative monetary flows. |
| `col_outflow` | `"#D95F02"` | Colors for positive and negative monetary flows. |
| `date_labels` | `"%Y-%m-%d"` | Calendar label format for ggplot2::scale_x_date() . |

## B06 — premium_gross

Documentación: `man/premium_gross.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `prem` | `<obligatorio>` | A one-row data frame or tibble. The preferred input is premium_x(..., output = "summary") or premium_xy(..., output = "summary") . It must contain an annualized net premium and the APV of the normalized premium annuity. |
| `alpha` | `0` | Nonnegative numeric scalar. Initial acquisition expense as a multiple of one gross premium installment. The expense at issue is \alpha G^{(k)} / k . |
| `beta` | `0` | Numeric scalar in [0,1) . Proportional expense charged on every gross premium installment. |
| `gamma` | `0` | Nonnegative numeric scalar. Fixed monetary expense incurred at every premium-payment date. Its APV is \gamma k a^{(k)} , because a_premiums is normalized with payments of 1/k . |
| `k` | `NULL` | Optional positive integer payment frequency. By default it is inferred from payments_per_year or k in prem ; if neither is present, k = 1 is used. |
| `output` | `c("value", "summary", "audit", "table")` | Output level. "value" returns the annualized gross premium, "summary" returns a compact one-row tibble, and "audit" returns the extended-equivalence components in long format. "table" is accepted as a compatibility alias for "summary" . |
| `tidy` | `NULL` | Deprecated compatibility argument. TRUE maps to output = "summary" and FALSE to output = "value" . |
| `check` | `TRUE` | Logical scalar. If TRUE , validates the inputs. |
| `tol` | `1e-10` | Nonnegative finite numeric tolerance. Monetary consistency is checked relatively to the compared amounts, without a one-currency-unit floor; frequency and integer checks use absolute tolerance. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility. The deprecated argument payments_per_year is mapped to k . |

## B06 — premium_x

Documentación: `man/premium_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table containing at least columns x and lx , or a single-life contract created with life_contract . |
| `x` | `<obligatorio>` | Integer actuarial age at issue. Optional when lt is a single-life contract. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. Optional when lt is a single-life contract. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal interest-rate inputs. |
| `type` | `c("whole", "term", "endowment", "variable_k")` | Insurance type. One of "whole" , "term" , "endowment" , or "variable_k" . |
| `benefit` | `1` | Benefit amount. For standard products, a single nonnegative numeric value. For type = "variable_k" , a numeric vector or a function of time may be supplied. |
| `n` | `Inf` | Insurance term in years. Use Inf for whole-life insurance. For type = "variable_k" , fractional terms aligned with the benefit frequency are permitted; the default Inf infers a finite term from a numeric benefit schedule. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `k` | `1L` | Positive integer. Number of premium payments per year. |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption. One of "UDD" , "CF" , "CML" , or "Balducci" . |
| `timing` | `c("due", "immediate")` | Premium timing: "due" or "immediate" . |
| `premium_start` | `c("issue", "deferred")` | Start of premium payments: "issue" or "deferred" . |
| `n_prem` | `NULL` | Premium-paying term in years. If finite, n_prem * k must be an integer. |
| `woolhouse` | `c("none", "first", "second")` | Woolhouse approximation order for the premium annuity: "none" , "first" , or "second" . |
| `output` | `c("value", "summary", "audit")` | Output level. "value" returns the annualized premium as a numeric scalar; "summary" returns a compact one-row executive summary; "audit" returns the components of the equivalence calculation in long format. |
| `tidy` | `NULL` | Deprecated compatibility argument. TRUE maps to output = "summary" and FALSE maps to output = "value" when output is not supplied. |
| `check` | `TRUE` | Logical scalar. If TRUE , performs input validation. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age , rate , rate_type , insurance_type , term_years , deferral_years , payments_per_year , premium_timing , and premium_term_years . |

## B06 — reserve_x

Documentación: `man/reserve_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table containing columns x and lx , or a single-life contract created with life_contract . |
| `x` | `<obligatorio>` | Integer actuarial age at issue. Optional for a life contract. |
| `i` | `<obligatorio>` | Numeric scalar. Annual interest-rate input. Optional for a life contract. |
| `i_type` | `"effective"` | Interest-rate type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal interest rates. |
| `type` | `c("whole", "term", "endowment")` | Insurance type: "whole" , "term" , or "endowment" . |
| `n` | `Inf` | Insurance term in years. Use Inf for whole-life insurance. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `benefit` | `1` | Positive insurance benefit. |
| `P` | `NULL` | Optional annualized premium P^{(k)} . If NULL , it is calculated with premium_x by the equivalence principle. |
| `k` | `1L` | Positive integer. Number of premium payments per year. |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption for exact k-thly premium annuities. |
| `timing` | `c("due", "immediate")` | Premium timing. Currently only "due" is supported, which gives reserves immediately before any premium payable at duration t . |
| `premium_start` | `c("issue", "deferred")` | Start of premium payments: "issue" or "deferred" . |
| `n_prem` | `NULL` | Premium-paying term in years. A fractional term is permitted when n_prem * k is an integer. |
| `woolhouse` | `c("none", "first", "second")` | Woolhouse approximation order for the premium annuity: "none" , "first" , or "second" . |
| `t` | `NULL` | Optional integer vector of policy durations. If NULL , all supported integer durations are returned. |
| `method` | `c("prospective", "recursive")` | Reserve method: "prospective" or "recursive" . The recursive method currently supports annual premiums only ( k = 1 ). |
| `output` | `c("summary", "value", "audit", "table")` | Output level. "summary" returns a compact reserve schedule, "value" returns a named numeric vector, and "audit" returns the reserve components in long format. "table" is accepted as a deprecated alias for "summary" . |
| `tidy` | `NULL` | Deprecated compatibility argument. TRUE maps to output = "summary" and FALSE to output = "value" . |
| `check` | `TRUE` | Logical scalar. If TRUE , validates inputs. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age , rate , rate_type , insurance_type , term_years , premium , premium_term_years , and durations . |

## B07 — annuity_xy

Documentación: `man/annuity_xy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-04: firma y esquema preservados, pagos firmados de 11/10/01 con masas
fraccionarias directas y base log original. C15 autorizada exige bordes
positivos y año siguiente en second. Truncación de marginales abiertas
preservada y documentada; ver audit-multilife-contingencies.md.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table, a list of two life tables list(lt_x, lt_y) , or a tidyact_life_contract object created by life_contract . Each life table must contain columns x and lx . |
| `x` | `NULL` | Integer actuarial age for the first life. |
| `y` | `NULL` | Integer actuarial age for the second life. |
| `i` | `NULL` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `status` | `c("joint", "last")` | Character string. Use "joint" for joint-life payments while both lives are alive, or "last" for last-survivor payments while at least one life is alive. Ignored when benefit is supplied. |
| `benefit` | `NULL` | Optional list with numeric scalar weights both , x_only , and y_only . These weights define the payment rate according to the survival state of the two lives. |
| `n` | `Inf` | Term in years. Use Inf for the maximum horizon allowed by the life tables. For exact k-thly valuation ( woolhouse = "none" ), fractional terms are allowed when n * k is an integer. Woolhouse approximations require an integer number of years. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `k` | `1L` | Positive integer. Number of payments per year. The annuity is normalized to an annual payment rate of 1, so each individual payment has amount 1 / k . |
| `timing` | `c("immediate", "due")` | Payment timing. Use "immediate" or "due" . |
| `woolhouse` | `c("none", "first", "second")` | Woolhouse approximation for k > 1 : "none" , "first" , or "second" . |
| `frac` | `<obligatorio>` | Fractional-age assumption for exact k-thly computation: "UDD" , "CF" , "CML" , or "Balducci" . |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric APV. If TRUE , returns a one-row tibble. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age_x , age_y , rate , rate_type , cohort , term_years , deferment_years , payments_per_year , and output . |

## B07 — e_xy

Documentación: `man/e_xy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-01: el atributo CML se normaliza a CF; firma y esquema preservados.
La revisión restante se concilió en B07-06; ver audit-multilife-contingencies.md.
B07-02: coherencia de tabla anual siempre validada (umbral mortal 1e-10),
controles lógicos y tol finito no negativo; rango integer con check=TRUE.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table data frame with columns x and lx . |
| `x` | `<obligatorio>` | Integer actuarial age for life 1. |
| `y` | `<obligatorio>` | Integer actuarial age for life 2. |
| `t` | `NULL` | Optional nonnegative numeric duration(s). If NULL , uses the maximum horizon allowed by the table. |
| `type` | `c("curtate", "complete")` | Character: "curtate" or "complete" . |
| `frac` | `<obligatorio>` | Fractional-age assumption for type = "complete" , as in t_pxy : "UDD" , "CF" , "CML" , or "Balducci" . If not specified and lt carries a frac attribute, that value is used; inherited CML is normalized to CF. |
| `cohort` | `c("first", "last")` | Two-life cohort: "first" (joint-life) or "last" (last survivor). |
| `tidy` | `FALSE` | Logical. If TRUE , returns a tibble. |
| `check` | `TRUE` | Logical. If TRUE , performs basic input checks. |
| `tol` | `1e-10` | Numeric tolerance for integer checks. |

## B07 — insurance_xy

Documentación: `man/insurance_xy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-03: firma/esquema intactos, valoración anual desde estado inicial 11 por
masas de transición. C13 autorizada exige extinción observada para whole;
C14 autorizada paga endowment n=0 en h si sobrevive el estado. No admite k,
pure_endowment ni estado inicial 10/01. Ver audit-multilife-contingencies.md.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table, a list of two life tables list(lt_x, lt_y) , or a tidyact_life_contract object created by life_contract . Each life table must contain columns x and lx . |
| `x` | `NULL` | Integer actuarial age for the first life. |
| `y` | `NULL` | Integer actuarial age for the second life. |
| `i` | `NULL` | Numeric scalar. Annual interest-rate input. |
| `i_type` | `"effective"` | Character string indicating the interest-rate type. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. Ignored for i_type = "effective" and i_type = "force" . |
| `type` | `c("whole", "term", "endowment")` | Character string. One of "whole" , "term" , or "endowment" . |
| `status` | `c("joint", "last")` | Character string. Use "joint" for first-death insurance or "last" for second-death insurance. |
| `n` | `Inf` | Term in years. Required as finite for term and endowment insurance. Use Inf for whole-life insurance. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `benefit` | `1` | Numeric scalar. Insurance benefit. |
| `frac` | `<obligatorio>` | Fractional-age assumption used in two-life survival probabilities. One of "UDD" , "CF" , "CML" , or "Balducci" . |
| `tidy` | `FALSE` | Logical scalar. If FALSE , returns a numeric APV. If TRUE , returns a one-row tibble. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age_x , age_y , rate , rate_type , insurance_type , cohort , term_years , deferment_years , and output . |

## B07 — premium_xy

Documentación: `man/premium_xy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-05: dotal puro por supervivencia monetaria directa y equivalencia P*a=B;
P anualizada, cuota P/k, firma y seis columnas summary preservadas. Una póliza
por llamada; denominador positivo/finito/representable todavía requerido.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table, a list of two life tables list(lt_x, lt_y) , or a two-life contract created with life_contract . |
| `x` | `NULL` | Integer actuarial age for the first life. Optional for a life_contract . |
| `y` | `NULL` | Integer actuarial age for the second life. Optional for a life_contract . |
| `i` | `NULL` | Numeric scalar. Annual interest-rate input. Optional for a life_contract . |
| `i_type` | `"effective"` | Interest-rate type: "effective" , "nominal_interest" , "nominal_discount" , or "force" . |
| `m` | `1L` | Positive integer. Conversion frequency for nominal rates. |
| `type` | `c("whole", "term", "endowment", "pure_endowment")` | Insurance type: "whole" , "term" , "endowment" , or "pure_endowment" . |
| `benefit` | `1` | Nonnegative insurance benefit. |
| `n` | `Inf` | Insurance term in years after deferment. Use Inf for whole-life insurance. |
| `h` | `0L` | Nonnegative integer deferment period in years. |
| `k` | `1L` | Positive integer. Number of premium payments per year. |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption: "UDD" , "CF" , "CML" , or "Balducci" . |
| `timing` | `c("due", "immediate")` | Premium timing: "due" or "immediate" . |
| `premium_start` | `c("issue", "deferred")` | Start of premiums: "issue" or "deferred" . |
| `n_prem` | `NULL` | Premium-paying term in years. A fractional value is permitted when n_prem * k is an integer. |
| `status` | `c("joint", "last")` | Two-life status: "joint" or "last" . For a life_contract , the value is inferred from lives unless supplied explicitly. |
| `woolhouse` | `c("none", "first", "second")` | Woolhouse approximation order for the premium annuity: "none" , "first" , or "second" . |
| `output` | `c("value", "summary", "audit", "table")` | Output level. "value" returns the annualized premium; "summary" returns a compact one-row result; "audit" returns the equivalence components in long format. "table" is accepted as a deprecated alias for "summary" . |
| `tidy` | `NULL` | Deprecated compatibility argument. TRUE maps to output = "summary" and FALSE to output = "value" . |
| `check` | `TRUE` | Logical scalar. If TRUE , validates inputs. |
| `tol` | `1e-10` | Numeric tolerance for integer-grid checks. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using mortality_table , age_x , age_y , rate , rate_type , insurance_type , term_years , deferment_years , payments_per_year , premium_timing , premium_term_years , and cohort . |

## B07 — reserve_xy

Documentación: `man/reserve_xy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-05: dotal puro directo, ambas recursiones hacia atrás con tasa original,
last conserva 11/10/01; C16 autorizada incluye prima vencida exactamente en t.
Estado condicionante 11 y restricciones de recursión preservados. Firma y
esquemas sin cambios; ver audit-multilife-contingencies.md para alcance/límites.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | One life table, `list(lt_x, lt_y)`, or a two-life [life_contract()] object. |
| `x` | `NULL` | Integer ages at issue. Optional for a life contract. |
| `y` | `NULL` | Integer ages at issue. Optional for a life contract. |
| `i` | `NULL` | Annual interest-rate input. Optional for a life contract. |
| `i_type` | `"effective"` | Interest-rate type. |
| `m` | `1L` | Conversion frequency for nominal rates. |
| `type` | `c("whole", "term", "endowment", "pure_endowment")` | One of `"whole"`, `"term"`, `"endowment"`, or `"pure_endowment"`. |
| `status` | `c("joint", "last")` | `"joint"` or `"last"`. |
| `n` | `Inf` | Insurance term in years after deferment. |
| `h` | `0L` | Nonnegative integer deferment in years. |
| `benefit` | `1` | Positive benefit amount. |
| `P` | `NULL` | Optional annualized premium. If `NULL`, [premium_xy()] is used. |
| `n_prem` | `NULL` | Premium-paying term. Fractional values require `n_prem * k` to be an integer. |
| `k` | `1L` | Number of premium payments per year. |
| `timing` | `c("due", "immediate")` | `"due"` or `"immediate"`. |
| `premium_start` | `c("issue", "deferred")` | `"issue"` or `"deferred"`. |
| `frac` | `c("UDD", "CF", "CML", "Balducci")` | Fractional-age assumption. |
| `woolhouse` | `c("none", "first", "second")` | `"none"`, `"first"`, or `"second"`. |
| `t` | `NULL` | Integer policy durations. |
| `method` | `c("prospective", "recursive")` | `"prospective"` or `"recursive"`. Recursion currently requires `h = 0`, `k = 1`, due premiums, and premiums starting at issue. |
| `output` | `c("summary", "value", "audit", "table")` | `"summary"`, `"value"`, or `"audit"`. `"table"` is a compatibility alias for `"summary"`. |
| `tidy` | `NULL` | Deprecated logical output selector. |
| `check` | `TRUE` | Logical input-check switch. |
| `tol` | `1e-10` | Numeric tolerance. |
| `...` | `<argumentos adicionales; sin default>` | Deprecated argument aliases. |

## B07 — t_pxy

Documentación: `man/t_pxy.Rd`. Semántica: conciliada en B07-06 dentro del alcance y límites documentados.

B07-01: atributos CF/CML equivalentes; se normalizan antes de compararlos.
Firma y esquema preservados; revisión restante conciliada en B07-06.
B07-02: tablas anuales coherentes, edades integer representables y duración
finita requeridas; se preservan convenciones de t=0/NA/horizonte.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | Either: a single life table data frame, used for both lives; or a list of two life tables list(lt_x, lt_y) , one for each life. Each life table must contain columns x and lx . |
| `x` | `<obligatorio>` | Integer actuarial age of the first life at time 0. |
| `y` | `<obligatorio>` | Integer actuarial age of the second life at time 0. |
| `t` | `<obligatorio>` | Nonnegative time (may be fractional). |
| `frac` | `<obligatorio>` | Fractional-age assumption: "UDD" , "CF" , "CML" (alias of CF), or "Balducci" . If not specified and the supplied life table(s) carry a frac attribute, that value is used. If two tables are supplied and their normalized frac attributes differ, frac must be supplied explicitly. Uses the same assumptions as t_px, with observed lx/log survival. |
| `status` | `c("joint", "last")` | Two-life status: "joint" or "last" . |

## B08 — mc_annuity

Documentación: `man/mc_annuity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble containing simulated future lifetimes, typically returned by simulate_lifetime or by mc_multilife_status when working with multiple-life statuses. For life-contingent calculations, observed curtate lifetimes must be finite nonnegative integers and observed complete lifetimes finite and nonnegative. Paired observations must satisfy K_x \le T_x < K_x+1 . |
| `i` | `<obligatorio>` | Numeric scalar. Interest-rate input used for discounting. |
| `payment` | `1` | Numeric scalar. Amount paid at each annuity payment date. Default is 1 . This is a per-payment amount, not an annualized payment rate. |
| `k` | `1L` | Positive integer. Number of annuity payments per year. Default is 1 , corresponding to annual payments. |
| `type` | `c("whole", "temporary", "deferred", "deferred_temporary", "certain", "guaranteed", "whole_life")` | Character string specifying the annuity type. Canonical options are "whole" , "temporary" , "deferred" , "deferred_temporary" , "certain" , and "guaranteed" . The transitional alias "whole_life" is also accepted and mapped to "whole" . |
| `n` | `NULL` | Numeric scalar. Term of the annuity in years. Required for "temporary" , "deferred_temporary" , and "certain" annuities. |
| `h` | `0` | Numeric scalar. Deferral period in years. Default is 0 . Required to be positive for "deferred" and "deferred_temporary" annuities. For fractional payments, the calendar is anchored at h , which need not be a multiple of 1 / k . |
| `n_guar` | `NULL` | Numeric scalar. Guaranteed payment period in years. Required for type = "guaranteed" . |
| `timing` | `c("immediate", "due")` | Character string specifying the annuity payment timing. Available options are "immediate" and "due" . |
| `i_type` | `c("effective", "nominal_interest", "nominal_discount", "force", "nominal")` | Character string specifying the interest-rate convention. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . The transitional value "nominal" is accepted and treated as "nominal_interest" . |
| `m` | `1` | Positive integer. Number of interest conversion periods per year for nominal annual rates. Default is 1 . This argument controls the interest-rate conversion frequency only. It does not represent annuity payment frequency. |
| `col_K` | `"Kx"` | Character string. Name of the column containing simulated curtate future lifetimes. Default is "Kx" . |
| `col_T` | `"Tx"` | Character string. Name of the column containing simulated complete future lifetimes. Default is "Tx" . This column is required when k > 1 , except for annuities certain. |
| `col_pv` | `"pv_annuity"` | Character string. Name of the output column containing simulated present values of annuity payments. Default is "pv_annuity" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using data , rate , payments_per_year , annuity , term , deferral_years , guarantee_years , interest_type , k_col , tx_col , and annuity_col . |

## B08 — mc_insurance

Documentación: `man/mc_insurance.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble containing simulated future lifetimes, typically returned by simulate_lifetime or by mc_multilife_status when working with multiple-life statuses. Observed curtate lifetimes must be finite nonnegative integers and observed complete lifetimes finite and nonnegative. Paired observations must satisfy K_x \le T_x < K_x+1 ; missing values remain missing. |
| `i` | `NULL` | Numeric scalar. Interest-rate input used for discounting. |
| `benefit` | `1` | Numeric scalar. Monetary amount paid when the insured benefit is triggered. Default is 1 . Unlike an annuity payment, this is a single benefit amount and has no annualized-versus-per-payment interpretation. |
| `type` | `c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment", "whole_life", "deferred_temporary")` | Character string specifying the insurance type. Canonical options are "whole" , "term" , "deferred" , "deferred_term" , "pure_endowment" , and "endowment" . Transitional aliases "whole_life" and "deferred_temporary" are also accepted. |
| `n` | `NULL` | Numeric scalar. Insurance term in years. Required for "term" , "deferred_term" , "pure_endowment" , and "endowment" . |
| `h` | `0` | Numeric scalar. Deferral period in years. Default is 0 . Required to be positive for "deferred" and "deferred_term" insurance. |
| `timing` | `c("end_of_year", "moment_of_death")` | Character string specifying when death benefits are paid. Available options are "end_of_year" and "moment_of_death" . Default is "end_of_year" . |
| `i_type` | `c("effective", "nominal_interest", "nominal_discount", "force", "nominal")` | Character string specifying the interest-rate convention. Allowed values are "effective" , "nominal_interest" , "nominal_discount" , and "force" . The transitional value "nominal" is accepted and treated as "nominal_interest" . |
| `m` | `1` | Positive integer. Number of interest conversion periods per year for nominal annual rates. Default is 1 . This argument controls the interest-rate conversion frequency only. It does not represent benefit frequency or premium payment frequency. |
| `col_K` | `"Kx"` | Character string. Name of the column containing simulated curtate future lifetimes. Default is "Kx" . |
| `col_T` | `"Tx"` | Character string. Name of the column containing simulated complete future lifetimes. Required when timing = "moment_of_death" . Default is "Tx" . |
| `col_pv` | `"pv_benefit"` | Character string. Name of the output column containing simulated present values of benefits. Default is "pv_benefit" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using data , rate , insurance , term , deferral_years , payment_timing , interest_type , k_col , tx_col , and benefit_col . |

## B08 — mc_loss

Documentación: `man/mc_loss.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble containing simulated present values of benefits and premium annuities. |
| `col_Z` | `"pv_benefit"` | Character scalar naming the simulated present value of benefits. Default is "pv_benefit" . |
| `col_Y` | `"pv_annuity"` | Character scalar naming the simulated present value of the premium annuity. Default is "pv_annuity" . |
| `col_P` | `"P"` | Character scalar naming the premium input column. When omitted, the function searches, in order, for premium_annualized , premium_per_payment , P , and premium . |
| `col_L` | `"L"` | Character scalar naming the simulated loss output. Default is "L" . |
| `P` | `NULL` | Optional nonnegative numeric scalar supplied directly instead of reading a premium column. |
| `premium_unit` | `c("auto", "annualized", "per_payment", "annuity_scale")` | Unit of P or the selected premium column: "annualized" , "per_payment" , or "annuity_scale" . The latter is the coefficient that directly multiplies col_Y . With "auto" , explicit modern column names determine the unit, while P , premium , and a direct P argument retain their historical annuity-scale interpretation. |
| `k` | `NULL` | Optional positive integer number of premium payments per year. By default it is inferred from payments_per_year or k in .data ; if neither exists, k = 1 is used. |
| `annuity_payment` | `NULL` | Optional positive numeric scalar giving the payment amount used to construct col_Y . It is normally inferred from payment_per_payment , payment , or payment_annualized in the output of mc_annuity . |
| `tol` | `1e-10` | Nonnegative numeric tolerance for consistency checks. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using data , benefit_col , annuity_col , premium_col , loss_col , and premium . |

## B08 — mc_multilife_status

Documentación: `man/mc_multilife_status.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

B08-02: C17 implementada, identidades min/max y almacenamiento cotejados;
identificadores no pueden colisionar con nombres de salida ya reservados.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `data` | `<obligatorio>` | A data frame or tibble, typically returned by simulate_lifetimes . |
| `status` | `c("joint", "last_survivor")` | Multiple-life status. Canonical values are "joint" and "last_survivor" . The aliases "joint_life" , "last" , and "last_survivor_life" are accepted. |
| `col_sim` | `"sim_id"` | Character scalar naming the simulation identifier column. |
| `col_life` | `"life_id"` | Character scalar naming the life identifier column. The default is "life_id" . Supply NULL only when no life identifier exists; in that case the function can validate equal row counts across simulations but cannot detect duplicated or substituted lives. |
| `col_K` | `"Kx"` | Character scalar naming the curtate future lifetime column. |
| `col_T` | `"Tx"` | Character scalar naming the complete future lifetime column. |
| `tol` | `1e-10` | Nonnegative numeric tolerance for checking whole-number curtate lifetimes. It does not relax the interval K <= T < K+1. |

## B08 — mc_premium

Documentación: `man/mc_premium.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble containing simulated present values. Usually obtained after applying mc_insurance and mc_annuity to the same simulated lifetime sample. |
| `col_Z` | `"pv_benefit"` | Character scalar naming the simulated present value of benefits. Default is "pv_benefit" . |
| `col_Y` | `"pv_annuity"` | Character scalar naming the simulated present value of the premium annuity. Default is "pv_annuity" . |
| `col_P` | `"P"` | Character scalar naming the compatibility output containing the coefficient that directly multiplies col_Y . Default is "P" . For a normalized k -thly premium annuity constructed with payment = 1 / k , this coefficient is the annualized premium. |
| `by` | `NULL` | Optional character vector of grouping columns. If supplied, the premium is estimated separately within each group. If by = NULL and .data is already grouped, the current grouping is used. |
| `na_rm` | `TRUE` | Logical scalar. If TRUE , simulations with a missing benefit or annuity present value are removed as complete pairs. The same simulation rows are therefore used in both means. |
| `k` | `NULL` | Optional positive integer number of premium payments per year. By default it is inferred from payments_per_year or k in .data ; if neither exists, k = 1 is used. |
| `annuity_payment` | `NULL` | Optional positive numeric scalar giving the amount paid at each date when col_Y was constructed. It is normally inferred from payment_per_payment , payment , or payment_annualized in the output of mc_annuity . |
| `tol` | `1e-10` | Nonnegative numeric tolerance for consistency checks. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using data , benefit_col , annuity_col , and premium_col . |

## B08 — mc_reserve

Documentación: `man/mc_reserve.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data frame or tibble containing simulated curtate future lifetimes and, when required, complete future lifetimes. Observed curtate lifetimes must be finite nonnegative integers and observed complete lifetimes finite and nonnegative. Paired observations must satisfy K_x \le T_x < K_x+1 ; missing values remain missing. |
| `t` | `0` | Nonnegative numeric vector of valuation durations. |
| `i` | `NULL` | Numeric scalar. Interest-rate input used for discounting. |
| `P` | `NULL` | Optional nonnegative numeric scalar supplied directly as the premium input. |
| `col_P` | `"P"` | Character scalar naming a premium column in .data . The default is "P" . When it is not supplied explicitly, modern standardized premium columns are preferred. |
| `premium_unit` | `c("auto", "annualized", "per_payment", "annuity_scale")` | Unit of P or the selected premium column: "annualized" , "per_payment" , or "annuity_scale" . With "auto" , premium_annualized , premium_per_payment , and premium_annuity_scale determine their own units, while legacy P and premium retain their historical annuity-scale interpretation. |
| `benefit` | `1` | Nonnegative numeric scalar. Insurance benefit amount. |
| `payment` | `1` | Positive numeric scalar. Amount used at each premium-annuity payment date. For the normalized k -thly convention, use payment = 1 / k . |
| `k` | `1L` | Positive integer number of premium payments per year. |
| `type` | `c("whole", "term", "deferred", "deferred_term", "pure_endowment", "endowment", "whole_life", "deferred_temporary")` | Insurance type. Supported values are "whole" , "term" , "deferred" , "deferred_term" , "pure_endowment" , and "endowment" . |
| `annuity_type` | `c("whole", "temporary", "deferred", "deferred_temporary", "certain", "guaranteed", "whole_life")` | Premium-annuity type. Supported values are "whole" , "temporary" , "deferred" , "deferred_temporary" , "certain" , and "guaranteed" . |
| `n` | `NULL` | Optional contract or premium term in years. |
| `h` | `0` | Nonnegative deferral period in years. |
| `n_guar` | `NULL` | Optional guaranteed premium-payment period in years. |
| `timing` | `c("end_of_year", "moment_of_death")` | Death-benefit timing: "end_of_year" or "moment_of_death" . |
| `premium_timing` | `c("due", "immediate")` | Premium-annuity timing: "due" or "immediate" . |
| `reserve_timing` | `c("before_payment", "after_payment")` | Whether cash flows exactly at the valuation duration are included: "before_payment" or "after_payment" . |
| `i_type` | `c("effective", "nominal_interest", "nominal_discount", "force", "nominal")` | Interest-rate convention. |
| `m` | `1` | Positive integer nominal conversion frequency. |
| `col_K` | `"Kx"` | Curtate future lifetime column. |
| `col_T` | `"Tx"` | Complete future lifetime column. |
| `in_force_basis` | `c("auto", "complete", "curtate")` | Basis used to determine whether a simulated policy is in force: "auto" , "complete" , or "curtate" . |
| `not_in_force` | `c("na", "zero")` | Output for known scenarios that are not in force: "na" or "zero" . Missing lifetime information remains missing under either option. |
| `col_L` | `"L_t"` | Output column containing the prospective loss. |
| `tol` | `1e-10` | Nonnegative numeric tolerance for consistency checks. |
| `premium` | `NULL` | Deprecated explicit alias for P . It remains a formal argument because otherwise R partially matches it against premium_unit and premium_timing . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older argument names. |

## B08 — simulate_annuity_x

Documentación: `man/simulate_annuity_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table or a tidyact_life_contract . A life table must contain columns x and lx . |
| `x` | `NULL` | Integer actuarial age. Optional for a life contract. |
| `i` | `NULL` | Numeric scalar interest-rate input. |
| `i_type` | `NULL` | Interest-rate convention. |
| `m` | `NULL` | Positive integer nominal conversion frequency. |
| `n` | `Inf` | Positive integer term in years, or Inf for whole life. |
| `k` | `1L` | Positive integer number of annuity payments per year. |
| `timing` | `c("due", "immediate")` | Payment timing: "due" or "immediate" . |
| `payment` | `1` | Nonnegative amount paid at each payment date. To simulate an annualized payment rate of 1 with k payments per year, use payment = 1 / k . |
| `frac` | `c("udd", "cml", "balducci")` | Fractional-age assumption used to simulate the complete lifetime within the year of death: "udd" , "cml" , or "balducci" . |
| `method` | `c("inverse")` | Simulation method. Currently only "inverse" . |
| `n_sim` | `10000L` | Positive integer number of simulations. |
| `seed` | `NULL` | Optional nonnegative integer seed. |
| `output` | `c("simulations", "summary")` | "simulations" or "summary" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for mortality_table , age , rate , rate_type , term_years , and payments_per_year . |

## B08 — simulate_insurance_x

Documentación: `man/simulate_insurance_x.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A life table or a tidyact_life_contract . |
| `x` | `NULL` | Integer actuarial age. |
| `i` | `NULL` | Numeric scalar interest-rate input. |
| `i_type` | `NULL` | Interest-rate convention. |
| `m` | `NULL` | Positive integer nominal conversion frequency. |
| `type` | `c("whole", "term", "endowment")` | "whole" , "term" , or "endowment" . |
| `n` | `Inf` | Positive integer term, or Inf for whole life. |
| `benefit` | `1` | Nonnegative insurance benefit. |
| `method` | `c("inverse")` | Simulation method. Currently only "inverse" . |
| `n_sim` | `10000L` | Positive integer number of simulations. |
| `seed` | `NULL` | Optional nonnegative integer seed. |
| `output` | `c("simulations", "summary")` | "simulations" or "summary" . |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for mortality_table , age , rate , rate_type , insurance_type , and term_years . |

## B08 — simulate_lifetime

Documentación: `man/simulate_lifetime.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

B08-01: p positivo no se anula por tol en CML/Balducci; tol y edades se
validan antes de coerción, n_sim no puede redondear a cero y death_age
conserva valores fuera de integer. RNG y esquema ordinario preservados.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `lt` | `<obligatorio>` | A data frame or tibble containing the life table. |
| `x` | `<obligatorio>` | Nonnegative integer initial actuarial age. The age must appear explicitly in the column selected by x_col . |
| `n_sim` | `10000L` | Positive integer number of simulations. |
| `x_col` | `"x"` | Character scalar naming the age column. |
| `qx_col` | `"qx"` | Character scalar naming the one-year death-probability column. |
| `method` | `c("inverse", "multinomial", "antithetic")` | Simulation method for the curtate future lifetime: "inverse" , "multinomial" , or "antithetic" . |
| `frac` | `c("udd", "cml", "balducci", "none", "constant_force")` | Fractional-age assumption used inside the year of death: "udd" , "cml" , "balducci" , or "none" . The legacy value "constant_force" is accepted as an alias for "cml" . |
| `seed` | `NULL` | Optional nonnegative integer seed. When supplied, the caller's random-number state is restored after simulation. |
| `include_distribution` | `FALSE` | Logical scalar. If TRUE , the probability distribution used for simulation is attached as a list-column. |
| `truncation` | `c("conditional", "error")` | Treatment of a life table whose available death probabilities do not exhaust the lifetime distribution. With "conditional" , the historical behavior is retained and the probabilities are normalized conditional on death within the available ages, with a warning. With "error" , the simulation stops. |
| `tol` | `1e-10` | Nonnegative numeric tolerance used for age-grid and probability checks. |

## B08 — simulate_lifetimes

Documentación: `man/simulate_lifetimes.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

B08-01: exposición lx>0 independiente del radix y decrementos directos;
tol/edades/n_sim validados antes de coerción. Se conserva una sola corriente
por llamada, precedencia de columnas, truncación y esquemas.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `data` | `<obligatorio>` | A data frame or tibble containing a life table. |
| `x` | `<obligatorio>` | Nonempty numeric vector of nonnegative integer initial ages. Each position represents one life; repeated ages are allowed. |
| `n_sim` | `1000L` | Positive integer number of simulations per life. |
| `frac` | `c("udd", "cml", "balducci", "constant", "cfm", "constant_force")` | Fractional-age assumption. Canonical values are "udd" , "cml" , and "balducci" . The historical values "constant" , "cfm" , and "constant_force" are accepted as aliases for "cml" . |
| `method` | `c("inverse", "multinomial", "antithetic")` | Simulation method passed to simulate_lifetime : "inverse" , "multinomial" , or "antithetic" . |
| `seed` | `NULL` | Optional nonnegative integer seed. When supplied, one random stream is initialized for the complete multiple-life simulation and the caller's previous random-number state is restored afterward. |
| `truncation` | `c("conditional", "error")` | Treatment of a mortality table that does not exhaust the lifetime distribution: "conditional" retains the historical conditional simulation with one warning, while "error" stops. |
| `tol` | `1e-10` | Nonnegative numeric tolerance used for age and mortality checks. |

## B08 — summary_mc

Documentación: `man/summary_mc.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `.data` | `NULL` | A data.frame or tibble containing simulation output. |
| `col_value` | `"present_value"` | Character string. Name of the numeric column to summarise. Defaults to "present_value" . |
| `by` | `NULL` | Optional character vector of grouping columns. If supplied, the summary is computed separately within each group. If by = NULL and .data is already grouped with dplyr::group_by() , the current grouping structure is used. |
| `probs` | `c(0.025, 0.5, 0.975)` | Numeric vector of probabilities for quantiles. |
| `var_probs` | `c(0.95, 0.99)` | Numeric vector of probabilities for VaR and TVaR. |
| `na_rm` | `TRUE` | Logical scalar. If TRUE , missing values are removed before computing statistics. |
| `...` | `<argumentos adicionales; sin default>` | Transitional compatibility for older calls using data , value_col , and group_cols . |

## B09 — aggregate_distribution

Documentación: `man/aggregate_distribution.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A tidyact_collective_risk_spec object. |
| `method` | `c("auto", "analytic", "convolution", "panjer", "fft")` | Computational method. One of "auto" , "analytic" , "convolution" , "panjer" , or "fft" . |
| `tol` | `1e-08` | Positive finite probability tolerance smaller than one. It is used when an infinite claim-count distribution must be truncated numerically or when Panjer recursion is allowed to stop after capturing at least 1 - tol of the aggregate probability. |
| `max_loss` | `NULL` | Optional nonnegative finite numeric scalar giving the largest aggregate-loss value to retain in the returned grid. Probability above the retained grid is not renormalized; it is reported separately as tail_probability , together with any omitted claim-count probability. |
| `...` | `<argumentos adicionales; sin default>` | Reserved for future computational controls. Additional arguments are currently rejected. |

## B09 — aggregate_moments

Documentación: `man/aggregate_moments.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A tidyact_collective_risk_spec object created by collective_risk_spec() . |
| `order` | `1:4` | Nonempty numeric vector of nonnegative integer moment orders. Cumulant orders must be positive. |
| `type` | `"raw"` | One of "raw" (default), "central" , or "cumulant" . |

## B09 — apply_coverage

Documentación: `man/apply_coverage.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A severity specification inheriting from tidyact_severity_spec . It must represent nonnegative ground-up losses, not an existing payment specification. |
| `coverage` | `<obligatorio>` | A tidyact_coverage_spec object from coverage_spec() . |
| `label` | `NULL` | Optional nonempty character scalar. If NULL , the source severity label is inherited when present; otherwise the coverage label is used when present. |

## B09 — collective_risk_spec

Documentación: `man/collective_risk_spec.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `frequency` | `<obligatorio>` | A tidyact_frequency_spec object, typically created with frequency_spec() or empirical_frequency() . |
| `severity` | `<obligatorio>` | A tidyact_severity_spec object, typically created with severity_spec() or empirical_severity() . |
| `count_basis` | `NULL` | Either NULL , "loss" , or "payment" . The count basis indicates whether frequency counts underlying losses or positive payments. When NULL , the constructor uses basis information already carried by the component specifications when available; otherwise the default is "loss" . |
| `label` | `NULL` | Optional nonempty character scalar identifying the model. |

## B09 — coverage_spec

Documentación: `man/coverage_spec.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `deductible` | `0` | Nonnegative finite numeric scalar. The deductible applied to the inflated loss, possibly adjusted by index_deductible . |
| `limit` | `Inf` | Nonnegative numeric scalar, or Inf . Maximum covered amount after the deductible but before coinsurance . This is not the maximum ground-up loss and not necessarily the insurer's final payment limit. |
| `coinsurance` | `1` | Numeric scalar in [0, 1] . Fraction of the covered amount paid by the insurer, applied after the limit. Zero is allowed to represent a contract with no insurer participation. |
| `inflation_factor` | `1` | Positive finite numeric scalar multiplying the original loss. This is a factor , not a rate: use 1.10 for 10 percent inflation. |
| `deductible_type` | `c("ordinary", "franchise")` | Either "ordinary" (default) or "franchise" . Under a franchise deductible, a loss exceeding the deductible is payable from the first monetary unit, subject to the limit and coinsurance. |
| `index_deductible` | `FALSE` | Logical scalar. If TRUE , multiply the deductible by inflation_factor before applying it to the inflated loss. |
| `index_limit` | `FALSE` | Logical scalar. If TRUE , multiply the limit by inflation_factor before applying it. An infinite limit remains infinite. |
| `label` | `NULL` | Optional nonempty, non-whitespace character scalar identifying the contract. |

## B09 — discretize_severity

Documentación: `man/discretize_severity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A continuous tidyact_severity_spec object. |
| `step` | `<obligatorio>` | Positive finite numeric scalar giving the lattice spacing. |
| `to` | `NULL` | Optional positive finite upper grid point. It must be an integer multiple of step . If NULL , the upper point is selected from the (1 - tail_prob) quantile and rounded upward to the next grid point. |
| `method` | `c("unbiased", "upper", "lower", "rounding")` | Discretization method. One of "unbiased" , "upper" , "lower" , or "rounding" . |
| `tail_prob` | `1e-08` | Probability used to select to when to = NULL . Must satisfy 0 < tail_prob < 1 . |
| `label` | `NULL` | Optional nonempty character scalar. If NULL , the label of x is retained. |

## B09 — distribution_convolution

Documentación: `man/distribution_convolution.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A tidyact_distribution_spec object. |
| `y` | `NULL` | Optional second tidyact_distribution_spec object. Supply y for a pairwise convolution x + y . |
| `n` | `NULL` | Optional nonnegative integer scalar. Supply n for the iid convolution of n copies of x . |
| `label` | `NULL` | Optional nonempty character scalar identifying the convolution. |

## B09 — distribution_moments

Documentación: `man/distribution_moments.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A tidyact_frequency_spec or tidyact_severity_spec object. |
| `order` | `1:4` | Nonempty numeric vector of nonnegative integer moment orders. For cumulants, all orders must be positive. |
| `type` | `"raw"` | One of "raw" (default), "central" , "factorial" , or "cumulant" . Factorial moments are available only for frequency specifications. |

## B09 — empirical_frequency

Documentación: `man/empirical_frequency.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `data` | `<obligatorio>` | A nonempty numeric vector of observed nonnegative integer counts, or a data frame containing those counts. |
| `count` | `NULL` | For a data frame, an unquoted column containing the observed counts. Required for data-frame input and omitted for vector input. |
| `weight` | `NULL` | Optional nonnegative observation weights. For a data frame, provide an unquoted column; for a vector input, provide a numeric vector of the same length. When omitted, every row has weight one. Weights in a summarized frequency table may represent the number of policies having each claim count; they are not exposure offsets for fitting a rate. |
| `label` | `NULL` | Optional nonempty character scalar identifying the distribution. |

## B09 — empirical_severity

Documentación: `man/empirical_severity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `data` | `<obligatorio>` | A nonempty numeric vector of nonnegative observed claim amounts, or a data frame containing those amounts. |
| `amount` | `NULL` | For data-frame input, an unquoted column containing individual claim amounts. Required for data frames; omit for numeric vectors. |
| `weight` | `NULL` | Optional nonnegative observation weights. For data frames, supply an unquoted column; for vectors, supply a numeric vector of equal length. If omitted, all observations have weight one. In a summarized table, weights can represent the multiplicities of each observed amount. Weights are not exposure offsets or inputs to a fitted model. |
| `label` | `NULL` | Optional nonempty character scalar identifying the distribution. |

## B09 — frequency_spec

Documentación: `man/frequency_spec.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `dist` | `<obligatorio>` | Character scalar identifying the frequency distribution. Currently supported values are `"poisson"`, `"binomial"`, `"negative_binomial"`, `"geometric"`, and `"custom"`. |
| `...` | `<argumentos adicionales; sin default>` | Named parameters defining the selected distribution. |
| `custom` | `NULL` | Optional named list defining a custom count distribution. Used only when `dist = "custom"`. At minimum, the list must contain `pmf`, a probability mass function. |
| `label` | `NULL` | Optional character scalar used to identify the specification. |

## B09 — severity_spec

Documentación: `man/severity_spec.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `dist` | `<obligatorio>` | One of "exponential" , "gamma" , "lognormal" , "weibull" , "pareto" , "burr" , "loglogistic" , "degenerate" , "discrete" , or "custom" . |
| `...` | `<argumentos adicionales; sin default>` | Named distribution parameters, as described in Details . |
| `custom` | `NULL` | Named list of computational functions and support information when dist = "custom" ; NULL for built-in families. |
| `label` | `NULL` | Optional nonempty character scalar identifying the model. |

## B09 — simulate_aggregate

Documentación: `man/simulate_aggregate.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A [collective_risk_spec()] object. Zero-payment specifications produced by [to_payment_basis()] are also accepted. |
| `n_sim` | `1000L` | Positive integer number of independent realizations. |
| `seed` | `NULL` | Optional nonnegative integer random seed, restored after use. |
| `max_claims` | `1000000L` | Maximum total number of individual claim draws in one invocation. Exceeding this protective allocation limit is an error, not a truncation of the frequency distribution. |

## B09 — simulate_frequency

Documentación: `man/simulate_frequency.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A [frequency_spec()] or [empirical_frequency()] specification. |
| `n_sim` | `1000L` | Positive integer number of simulations. |
| `seed` | `NULL` | Optional nonnegative integer seed. When supplied, the caller's random-number state is restored after the call. |

## B09 — simulate_severity

Documentación: `man/simulate_severity.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A [severity_spec()], [empirical_severity()], or compatible payment severity specification. |
| `n_sim` | `1000L` | Positive integer number of simulations. |
| `seed` | `NULL` | Optional nonnegative integer seed; preserves the caller's RNG state when supplied. |

## B09 — stop_loss_premium

Documentación: `man/stop_loss_premium.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A nonnegative loss sample or simulation tibble, a supported severity specification, or an aggregate-distribution result. |
| `retention` | `0` | Finite nonnegative retention amount(s). |
| `value` | `NULL` | Optional name of a loss column when `x` is a data frame. |

## B09 — tail_value_at_risk

Documentación: `man/tail_value_at_risk.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | Finite nonnegative losses, a tibble of simulations, a supported severity specification, or an aggregate-distribution result. |
| `level` | `0.95` | Probabilities strictly between zero and one. |
| `value` | `NULL` | Optional loss column name for data frames. |

## B09 — to_payment_basis

Documentación: `man/to_payment_basis.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A list-backed collective risk specification containing frequency (a tidyact_frequency_spec ) and severity (a tidyact_payment_spec with basis = "per_loss" ). The collective class tidyact_collective_risk_spec , as provided by collective_risk_spec() . The input must have count_basis = "loss" . |
| `label` | `NULL` | Optional nonempty character scalar identifying the transformed model. If NULL , the collective model label is inherited when present. |

## B09 — value_at_risk

Documentación: `man/value_at_risk.Rd`. Semántica: revisión por bloque pendiente salvo evidencia específica.

| Parámetro, en orden real | Default | Concepto, dominio y unidades documentados |
|---|---|---|
| `x` | `<obligatorio>` | A vector of observed losses, a tibble of simulations, a severity specification with an exact quantile, or an [aggregate_distribution()] result. A zero-payment specification is also accepted. |
| `level` | `0.95` | Probability levels strictly between zero and one. |
| `value` | `NULL` | Optional character name of a loss column in a data frame. By default, `aggregate_loss`, `claim_amount`, `claim_count`, `loss`, or `payment` is selected (in that order). |
