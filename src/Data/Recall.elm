module Data.Recall exposing (..)

import Html exposing (Html)



-- MAIN (DO NOT USE)


main : Html ()
main =
    Html.text ""


type alias Recall =
    { recallId : Int
    , recallNumber : String
    , recallDate : String
    , description : String
    , url : String
    , title : String
    , consumerContact : String
    , lastPublishDate : String
    , isHighPriority : Bool
    , products : List Product
    , inconjunctions : List Inconjunction
    , images : List Image
    , injuries : List Injury
    , manufacturers : List RecallFirm
    , retailers : List RecallFirm
    , importers : List RecallFirm
    , distributors : List RecallFirm
    , manufacturerCounties : List ManufacturerCountry
    , productUPCs : List ProductUPC
    , hazards : List Hazard
    , remedies : List Remedy
    , remedyOptions : List RemedyOption
    }


stubRecall : Recall
stubRecall =
    Recall
        8769
        "20093"
        "4/2/2020"
        "This recall involves sodium hydroxide and potassium hydroxide products that are sold in three sizes: 4 ounce, 8-ounce and 1-pound. The products are labeled as being used for soaps, cleaners, water treatment, food preparation, pH buffer and metal dissolution. The potassium hydroxide products and the 4-ounce and 8-ounce sodium hydroxide products are sold in black resealable bags; the 1-pound sodium hydroxide product is sold in a white resealable bag. The sodium hydroxide product is stated as being food grade."
        "https://google.com"
        "Belle Chemical Recalls Sodium Hydroxide and Potassium Hydroxide Products Due to Failure to Meet Child-Resistant Packaging Requirement and Violation of FHSA Labeling Requirement"
        "Belle Chemical toll-free at 877-522-2233 from 8 a.m. to 4 p.m. MT Monday through Friday, email at info@bellechemical.com or online at www.bellechemical.com and click on RECALL INFORMATION for more information."
        "4/3/2020"
        False
        [ stubProduct ]
        [ stubInconjunction ]
        [ stubImage ]
        [ stubInjury ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubManufacturerCountry ]
        [ stubProductUPC ]
        [ stubHazard ]
        [ stubRemedy ]
        [ stubRemedyOption ]


stubRecall2 : Recall
stubRecall2 =
    Recall
        8769
        "20093"
        "4/2/2020"
        "This recall involves sodium hydroxide and potassium hydroxide products that are sold in three sizes: 4 ounce, 8-ounce and 1-pound. The products are labeled as being used for soaps, cleaners, water treatment, food preparation, pH buffer and metal dissolution. The potassium hydroxide products and the 4-ounce and 8-ounce sodium hydroxide products are sold in black resealable bags; the 1-pound sodium hydroxide product is sold in a white resealable bag. The sodium hydroxide product is stated as being food grade."
        "https://google.com"
        "Belle Chemical Recalls Sodium Hydroxide and Potassium Hydroxide Products Due to Failure to Meet Child-Resistant Packaging Requirement and Violation of FHSA Labeling Requirement"
        "Belle Chemical toll-free at 877-522-2233 from 8 a.m. to 4 p.m. MT Monday through Friday, email at info@bellechemical.com or online at www.bellechemical.com and click on RECALL INFORMATION for more information."
        "4/3/2020"
        False
        [ stubProduct ]
        [ stubInconjunction ]
        [ stubImage ]
        [ stubInjury ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubRecallFirm ]
        [ stubManufacturerCountry ]
        [ stubProductUPC ]
        [ stubHazard ]
        [ stubRemedy ]
        [ stubRemedyOption ]


type alias Product =
    { name : String
    , description : String
    , model : String
    , pType : String
    , categoryId : String
    , numberOfUnits : String
    }


stubProduct : Product
stubProduct =
    Product
        "Sodium Hydroxide, Lye/Caustic Soda and Potassium Hydroxide, Caustic Potash Ash"
        ""
        ""
        ""
        ""
        "About 103,000"


type alias Inconjunction =
    { url : String
    }


stubInconjunction : Inconjunction
stubInconjunction =
    Inconjunction
        ""


type alias Image =
    { url : String
    , caption : String
    }


stubImage : Image
stubImage =
    Image
        "https://www.cpsc.gov/s3fs-public/Screen Shot 2020-03-18 at 2.00.35 PM.png"
        "Recalled Sodium Hydroxide Lye/Caustic Soda (1 pound bag)"


type alias Injury =
    { name : String
    }


stubInjury : Injury
stubInjury =
    Injury
        "None reported."


type alias RecallFirm =
    { name : String
    , companyId : String
    }


stubRecallFirm : RecallFirm
stubRecallFirm =
    RecallFirm
        "Belle Chemical, of Billings, Mont."
        ""


type alias ManufacturerCountry =
    { country : String
    }


stubManufacturerCountry : ManufacturerCountry
stubManufacturerCountry =
    ManufacturerCountry
        "China"


type alias ProductUPC =
    { upc : String
    }


stubProductUPC : ProductUPC
stubProductUPC =
    ProductUPC
        "987"


type alias Hazard =
    { name : String
    , hazardType : String
    , hazardTypeId : String
    }


stubHazard : Hazard
stubHazard =
    Hazard
        "The products contain sodium hydroxide or potassium hydroxide which must be in child resistant packaging as required by the Poison Prevention Packaging Act (PPPA). The packaging of the products is not child resistant, posing a risk of chemical burns and irritation to the skin and eyes. In addition, the label on the product violates the Federal Hazardous Substance Act (FHSA) by omitting the word “poison” for poisonous chemicals and the mandatory hazard statement on the front on the packaging."
        "bad type"
        "0"


type alias Remedy =
    { name : String
    }


stubRemedy : Remedy
stubRemedy =
    Remedy
        "Consumers should immediately store the recalled products in a safe location out of reach of children and contact Belle Chemical for a free replacement child-resistant packaging and label to put on the product."


type alias RemedyOption =
    { option : String
    }


stubRemedyOption : RemedyOption
stubRemedyOption =
    RemedyOption
        "Replace"
