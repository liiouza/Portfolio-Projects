# Company Performance Dashboard

An Excel project that compares monthly revenue and costs with plan across three fictional business segments. It calculates profit and profit margin, summarizes results by month and segment, and displays the main trends in a dashboard. The data is synthetic and included so the workbook works immediately.

## Skills demonstrated

- Organizing a tidy source dataset
- Excel formulas (`SUMIFS`, `SUMIF`, and `IFERROR`)
- Budget versus actual analysis and variance calculations
- KPI summaries, monthly and segment analysis, and charts
- Clear separation between source inputs, calculations, and dashboard outputs

## Files

- `company_performance_dashboard.xlsx` is the finished, formula-driven workbook.
- `monthly_performance.csv` is the fictional source dataset used by the workbook.

## Open and explore

Open the workbook in Excel. Start on the `Dashboard` sheet. `Source Data` contains the monthly segment inputs and row-level calculations. Change an input in `Source Data` to see the linked dashboard totals and charts update.

## Demonstrations on key questions

- Did annual revenue and profit meet budget?
- Which months had the largest revenue and profit variances?
- Which business segment generated the most revenue and profit?
- How did actual profit margin compare across segments?

## Method

The source data has one row for each month and business segment. Dashboard monthly totals use `SUMIFS`; segment totals use `SUMIF`. The workbook calculates profit as revenue less costs and margin as profit divided by revenue. The source values are invented for demonstration and are not company results.

