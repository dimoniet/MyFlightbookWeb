<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.master" CodeFile="MapRoute2.aspx.cs" Inherits="MapRoute" Title="" %>
<%@ Register Src="../Controls/mfbGoogleMapManager.ascx" TagName="mfbGoogleMapManager"
    TagPrefix="uc1" %>
<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Register Src="../Controls/mfbImageList.ascx" TagName="mfbImageList" TagPrefix="uc5" %>
<%@ Register src="../Controls/mfbGoogleAdSense.ascx" tagname="mfbGoogleAdSense" tagprefix="uc2" %>
<%@ Register src="../Controls/mfbAirportServices.ascx" tagname="mfbAirportServices" tagprefix="uc4" %>
<%@ Register src="../Controls/mfbTooltip.ascx" tagname="mfbTooltip" tagprefix="uc6" %>
<asp:Content ID="ContentHead" ContentPlaceHolderID="cpPageTitle" runat="server">
    <asp:Label ID="lblPageHeader" runat="server" Text="Label"></asp:Label>
</asp:Content>
<asp:Content ID="ContentTopForm" ContentPlaceHolderID="cpTopForm" runat="server">
    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnMapEm">
        <asp:Localize ID="locMapPrompt" runat="server" Text="<%$ Resources:Airports, MapPrompt %>"></asp:Localize>
            <uc6:mfbTooltip ID="mfbTooltip1" runat="server" BodyContent="<%$ Resources:Airports, MapNavaidTip %>" />
        <br />
        <asp:TextBox ID="txtAirports" Width="600px" TextMode="MultiLine" Rows="1" runat="server"></asp:TextBox>
        <br />
        <asp:Button ID="btnMapEm" runat="server" OnClick="btnMapEm_Click" Text="<%$ Resources:Airports, MapUpdateMap %>" />
        <asp:Panel ID="pnlRestrictToFlown" runat="server" Visible="false">
            <asp:Button ID="btnSeeWhatsBeenFlown" runat="server" Text="Check what's flown" 
                onclick="btnSeeWhatsBeenFlown_Click" />
            <br />
            <p><asp:Label ID="lblVRStatus" runat="server" Text=""></asp:Label></p>
            <asp:Button ID="btnShowFlownSegmentDetail" runat="server" 
                Text="Show Flown Segment Detail" onclick="btnShowFlownSegmentDetail_Click" />
            <p><asp:Literal ID="litFlownStatus" runat="server"></asp:Literal></p>
            <asp:GridView ID="gvFlownSegments" runat="server" AutoGenerateColumns="false" 
                onrowdatabound="gvFlownSegments_RowDataBound">
                <Columns>
                    <asp:BoundField DataField="Segment" />
                    <asp:BoundField DataField="HasMatch" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="lblUser" runat="server" Text='<%# Bind("MatchingFlight.User") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkFlight" runat="server" Target="_blank"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="lblRoute" runat="server" Text='<%# Bind("MatchingFlight.Route") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Label ID="lblComment" runat="server" Text='<%# Bind("MatchingFlight.Comment") %>'></asp:Label>
                            <asp:Panel ID="pnlFlightImages" runat="server">
                                <uc5:mfbImageList ID="mfbilFlights" runat="server" Columns="2" CanEdit="false" ImageClass="Flight" IncludeDocs="false" MaxImage="-1" />
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Button ID="btnDownloadXML" runat="server" Text="Download XML" 
                onclick="btnDownloadXML_Click" />
            <br />
            <asp:FileUpload ID="fuXMLFlownRoutes" runat="server" />&nbsp;<asp:Button 
                ID="btnUploadXML" runat="server" Text="Initialize Flown Routes from XML" 
                onclick="btnUploadXML_Click" />
        </asp:Panel>
        <asp:HyperLink ID="lnkZoomOut" runat="server" NavigateUrl=""
            Visible="False" Text="<%$Resources:Airports, MapZoomOut %>"></asp:HyperLink>
        <br />
        <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
    </asp:Panel>
</asp:Content>
<asp:content id="Content1" contentplaceholderid="cpMain" runat="Server">
    <br />
    <div style="margin-left:20px; width:80%; float:left; clear:left;">
        <uc1:mfbGoogleMapManager ID="MfbGoogleMapManager1" runat="server" Height="600px" />
        <asp:Panel ID="pnlDistance" runat="server" Visible="false">
            <asp:Label ID="lblDistance" runat="server" Text=""></asp:Label>
        </asp:Panel>
        <uc4:mfbAirportServices ID="mfbAirportServices1" runat="server" ShowFBO="true" ShowHotels="true" ShowInfo="true" ShowMetar="true" ShowZoom="true" />
    </div>
    <div id="ads" style="float:right; width: 130px; padding:4px; clear:right;">
        <uc2:mfbGoogleAdSense ID="mfbGoogleAdSense2" runat="server" LayoutStyle="adStyleVertical" />
    </div>
        
    <div style="width:100%; clear:both; float:none;">&nbsp;</div>
</asp:content>