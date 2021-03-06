using MyFlightbook;
using System;

/******************************************************
 * 
 * Copyright (c) 2015-2020 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

public partial class Controls_mfbSimpleTotals : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        UpdateTotals();
    }

    public event EventHandler DateRangeChanged = null;

    public FlightQuery.DateRanges DateRange
    {
        get
        {
            switch (cmbTotals.SelectedValue)
            {
                case "All":
                    return FlightQuery.DateRanges.AllTime;
                case "MTD":
                    return FlightQuery.DateRanges.ThisMonth;
                case "PrevMonth":
                    return FlightQuery.DateRanges.PrevMonth;
                case "Trailing6":
                    return FlightQuery.DateRanges.Tailing6Months;
                case "YTD":
                    return FlightQuery.DateRanges.YTD;
                case "Trailing12":
                    return FlightQuery.DateRanges.Trailing12Months;
            }
            return FlightQuery.DateRanges.AllTime;
        }
    }

    protected void UpdateTotals()
    {
        mfbTotalSummary1.Recency = DateRange;
    }

    protected void cmbTotals_SelectedIndexChanged(object sender, EventArgs e)
    {
        DateRangeChanged?.Invoke(this, e);
    }
}
