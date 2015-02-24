//
//  Constants.h
//  iArtist
//
//  Created by Vitalii Zamirko on 2/23/15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#ifndef iArtist_Constants_h
#define iArtist_Constants_h

//server path

static NSString* const IAamazonServer = @"http://ec2-54-93-36-107.eu-central-1.compute.amazonaws.com";
static NSString* const IAamazonServerHostname = @"ec2-54-93-36-107.eu-central-1.compute.amazonaws.com";
static NSString* const IAlocalServer = @"http://192.168.103.5";

//notifications

static NSString* const IAsendInfo = @"SendInfo";
static NSString* const IAgoToPictures = @"GoToPictures";
static NSString* const IAcloseLoginView = @"NeddCloseLoginView";
static NSString* const IAsendMail = @"send mail";
static NSString* const IAgoogleShare = @"GoogleShare";
static NSString* const IAupdateSessioninfo = @"UpdateSessionInfo";
static NSString* const IAupdateSocialNetworkSessionInfo = @"UpdateSocialNetworkSessionInfo";

//user defaults

static NSString* const IAfirstRun = @"firstRun";
static NSString* const IAloggedIn = @"loggedIn";
static NSString* const IAloggedInWithFacebook = @"loggedInWithFacebook";
static NSString* const IAloggedInWithTwitter = @"loggedInWithTwitter";
static NSString* const IAloggedInWithGoogle = @"loggedInWithGoogle";
static NSString* const IAloggedInWithVkontakte = @"loggedInWithVkontakte";
static NSString* const IAinformationSent = @"informationSent";
static NSString* const IAid = @"id";
static NSString* const IAusername = @"username";
static NSString* const IAuseremail = @"useremail";

// segues
static NSString* const IAnewsToPicture = @"FromNewsToPicture";
static NSString* const IAfirstRunSegue = @"FirstRunSegue";
static NSString* const IAprofile = @"GoToProfile";
static NSString* const IAlogin = @"Login";
static NSString* const IAnews = @"News";
static NSString* const IAlike = @"pushToLiked";
static NSString* const IApictures = @"PictureView";
static NSString* const IAnewsCart = @"News Cart";
static NSString* const IAlikeToPicture = @"LikedToPicture";
static NSString* const IAlikeCart = @"Liked Cart";
static NSString* const IAartistInfo = @"ArtistInfo";
static NSString* const IAmodalToPreviewOnWall = @"ModalToPreviewOnWall";
static NSString* const IAmodalToDetail = @"ModalToDetail";
static NSString* const IAsimpleShare = @"SimpleShare";
static NSString* const IAshare = @"Share";

// social networks

static NSString* const IAtwitterAppKey = @"y8DNDO0szLitsLoo4tsVJWnwm";
static NSString* const IAtwitterAppSecret = @"2APu9hHFWBuUI7YlFIYG9JJOYuaKTEAtDWeAvnAwmvrmhM7Ict";
static NSString* const IAvkontakteAppID = @"4738060";
static NSString* const IAgoogleAppID = @"151071407108-tdf2fd0atjggs26i68tepgupb0501k8u.apps.googleusercontent.com";


//Bundle resources

static NSString* const IAdart = @"DArt";

//Our e-mail

static NSString* const IAteamEmail = @"iArtistGreatTeam@gmail.com";

//Carousels

    //price
    static NSString* const IApriceVeryLow = @"<750";
    static NSString* const IApriceLow = @"750-1500";
    static NSString* const IApriceMiddleLow = @"1500-3000";
    static NSString* const IApriceMiddleLevel = @"3000-4000";
    static NSString* const IApriceMiddleHigh = @"4000-5000";
    static NSString* const IApriceHigh = @"5000-6000";
    static NSString* const IApriceVeryHigh = @">6000";

    //style
    static NSString* const IAhistory = @"History";
    static NSString* const IAnature = @"Nature";
    static NSString* const IAmilitary = @"Military";
    static NSString* const IAportrait = @"Portrait";
    static NSString* const IAstillLife = @"Still life";
    static NSString* const IAvanitas = @"Vanitas";

    //size
    static NSString* const IAsizeSmall = @"Small";
    static NSString* const IAsizeMedium = @"Medium";
    static NSString* const IAsizeBig = @"Big";
    static NSString* const IAsizeVeryBig = @"Very Big";

    //material
    static NSString* const IAmaterialPastel = @"Pastel";
    static NSString* const IAmaterialOil = @"Oil on canvas";
    static NSString* const IAmaterialEnamel = @"Enamel";
    static NSString* const IAmaterialAcrylicOnCanvas = @"Acrylic on canvas";
    static NSString* const IAmaterialPencil = @"Colored pencil";
    static NSString* const IAmaterialAcrylicAndEnamel = @"Acrylic & Enamel";
    static NSString* const IAmaterialPastelOnCanvas = @"Pastel on canvas";

    //color
    static NSString* const IAcolorRed = @"Red";
    static NSString* const IAcolorBlue = @"Blue";
    static NSString* const IAcolorOrange = @"Orange";
    static NSString* const IAcolorGreen = @"Green";
    static NSString* const IAcolorYellow = @"Yellow";
    static NSString* const IAcolorGrey = @"Grey";
    static NSString* const IAcolorBrown = @"Brown";

#endif
