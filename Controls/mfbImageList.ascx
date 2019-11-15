<%@ Control Language="C#" AutoEventWireup="true" CodeFile="mfbImageList.ascx.cs" Inherits="Controls_mfbImageList" %>
<%@ Reference Control="~/Controls/mfbEditableImage.ascx" %>
<%@ Register Src="mfbEditableImage.ascx" TagName="mfbEditableImage" TagPrefix="uc1" %>
<asp:Repeater ID="rptImg" runat="server" OnItemDataBound="rptImg_ItemDataBound">
    <ItemTemplate>
        <div id="divImg" runat="server" class="ilItem">
            <uc1:mfbEditableImage ID='mfbEI' runat="server"
                ZoomLinkType="<%# MapLinkType %>"
                MFBImageInfo="<%# Container.DataItem %>"
                AltText="<%# AltText %>"
                CanEdit="<%# CanEditImage((MyFlightbook.Image.MFBImageInfo) Container.DataItem) %>"
                CanDelete="<%# CanEdit %>"
                CanMakeDefault="<%# CanMakeDefault %>"
                IsDefault='<%# DefaultImage != null && DefaultImage.CompareOrdinalIgnoreCase((string) Eval("ThumbnailFile")) == 0 %>'
                OnImageDeleted="HandleDeleteClick"
                OnImageMadeDefault="mfbEI_ImageMadeDefault"
                />
        </div>
    </ItemTemplate>
</asp:Repeater>
<asp:PlaceHolder ID="plcTable" runat="server"></asp:PlaceHolder>
<asp:HiddenField ID="hdnKey" runat="server" Value="" Visible="false" />
<asp:HiddenField ID="hdnBasePath" runat="server" Value="" Visible="false" />
<asp:HiddenField ID="hdnCanEdit" Value="0" Visible="false" runat="server" />
<asp:HiddenField ID="hdnColumns" Value="1" Visible="false" runat="server" />
<asp:HiddenField ID="hdnMaxImage" Value="10" Visible="false" runat="server" />
<asp:HiddenField ID="hdnAltText" Value="" Visible="false" runat="server" />
<asp:HiddenField ID="hdnMakeDefault" Value="false" Visible="false" runat="server" />
<asp:HiddenField ID="hdnDefaultImage" Value="" Visible="false" runat="server" />
