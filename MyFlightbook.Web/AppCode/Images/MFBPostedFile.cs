﻿using gma.Drawing.ImageInfo;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;

/******************************************************
 * 
 * Copyright (c) 2008-2020 MyFlightbook LLC
 * Contact myflightbook-at-gmail.com for more information
 *
*******************************************************/

namespace MyFlightbook.Image
{
    /// <summary>
    /// Pseudo HTTPPostedFile, since I can't create those.
    /// </summary>
    [Serializable]
    public class MFBPostedFile
    {
        #region Constructors
        public MFBPostedFile()
        {
        }

        public MFBPostedFile(HttpPostedFile pf) : this()
        {
            if (pf == null)
                throw new ArgumentNullException(nameof(pf));
            WriteStreamToTempFile(pf.InputStream);
            FileID = FileName = pf.FileName;

            ContentType = pf.ContentType;
            ContentLength = pf.ContentLength;
        }

        public MFBPostedFile(AjaxControlToolkit.AjaxFileUploadEventArgs e) : this()
        {
            if (e == null)
                throw new ArgumentNullException(nameof(e));

            using (Stream s = e.GetStreamContents())
                WriteStreamToTempFile(s);

            FileID = e.FileId;
            FileName = e.FileName;

            ContentType = e.ContentType;
            ContentLength = e.FileSize;
        }

        ~MFBPostedFile()
        {
            // We can't make MFBPostedFile be disposable because we hold it indefinitely in the session
            // But we're not holding anything open either. 
            // So on object deletion, clean up any temp files.
            CleanUp();
        }

        private void WriteStreamToTempFile(Stream s)
        {
            TempFileName = Path.GetTempFileName();
            using (FileStream fs = File.OpenWrite(TempFileName))
            {
                s.Seek(0, SeekOrigin.Begin);
                s.CopyTo(fs);
            }
        }
        #endregion

        #region properties
        /// <summary>
        /// File name for the file
        /// </summary>
        public string FileName { get; set; }

        /// <summary>
        /// MIME content type for the file
        /// </summary>
        public string ContentType { get; set; }

        /// <summary>
        /// The length of the file
        /// </summary>
        public int ContentLength { get; set; }

        /// <summary>
        /// The name of the temp file to which the data has been written, so that we're not holding a potentially huge file in memory.
        /// The file can be safely deleted at any time.
        /// </summary>
        public string TempFileName { get; private set; }

        /// <summary>
        /// The unique ID provided by the AJAX file upload control
        /// </summary>
        public string FileID { get; set; }

        private byte[] m_ThumbBytes = null;

        /// <summary>
        /// Returns the bytes of the posted file, converted if needed from HEIC.
        /// </summary>
        public byte[] CompatibleContentData()
        {
            if (TempFileName == null)
                return null;

            using (FileStream fs = File.OpenRead(TempFileName))
            {
                // Check for HEIC
                try
                {
                    using (System.Drawing.Image img = System.Drawing.Image.FromStream(fs))
                    {
                        // If we got here then the content is Drawing Compatible - i.e., not HEIC; just return contentdata
                        fs.Seek(0, SeekOrigin.Begin);
                        byte[] rgb = new byte[fs.Length];
                        fs.Read(rgb, 0, rgb.Length);
                        return rgb;
                    }
                }
                catch (Exception ex) when (ex is ArgumentException)
                {
                    return MFBImageInfo.ConvertStreamToJPG(fs);
                }
            }
        }
        
        /// <summary>
        /// The stream of the thumbnail file - computed once and cached in ThumbnailData
        /// </summary>
        public byte[] ThumbnailBytes()
        {
            if (m_ThumbBytes != null)
                return m_ThumbBytes;

            using (Stream s = GetInputStream())
            {
                string szTempFile = null;
                try
                {
                    using (System.Drawing.Image image = MFBImageInfo.DrawingCompatibleImageFromStream(s, out szTempFile))
                    {
                        Info inf = MFBImageInfo.InfoFromImage(image);
                        using (Bitmap bmp = MFBImageInfo.BitmapFromImage(inf.Image, MFBImageInfo.ThumbnailHeight, MFBImageInfo.ThumbnailWidth))
                        {
                            using (MemoryStream sOut = new MemoryStream())
                            {
                                bmp.Save(sOut, ImageFormat.Jpeg);
                                m_ThumbBytes = sOut.ToArray();
                            }
                        }
                    }
                }
                finally
                {
                    if (!String.IsNullOrEmpty(szTempFile) && File.Exists(szTempFile))
                        File.Delete(szTempFile);
                }
            }
            return m_ThumbBytes;
        }

        /// <summary>
        /// Returns a stream to the underlying data.
        /// MUST BE DISPOSED BY CALLER
        /// </summary>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1024:UsePropertiesWhereAppropriate")]
        public Stream GetInputStream()
        {
            return File.OpenRead(TempFileName);
        }

        public void CleanUp()
        {
            if (!String.IsNullOrEmpty(TempFileName) && File.Exists(TempFileName))
                File.Delete(TempFileName);
        }
        #endregion
    }
}