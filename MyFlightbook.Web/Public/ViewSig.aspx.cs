﻿using MyFlightbook;
using System;

/******************************************************
 * 
 * Copyright (c) 2015-2020 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

public partial class Public_ViewSig : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int idFlight = util.GetIntParam(Request, "id", LogbookEntry.idFlightNew);
        if (idFlight != LogbookEntry.idFlightNew)
        {
            LogbookEntry le = new LogbookEntry
            {
                FlightID = idFlight
            };
            le.LoadDigitalSig();

            byte[] sig = le.GetDigitizedSignature();

            if (sig != null && sig.Length > 0)
            {
                Response.ContentType = "image/png";
                Response.Clear();
                Response.BinaryWrite(sig);
                Response.End();
            }
        }
    }
}