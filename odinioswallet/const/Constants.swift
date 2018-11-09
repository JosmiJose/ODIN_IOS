import UIKit

struct Constants {
    struct tokens {
        static let tokensKey="tokens_key"
    }
    struct minEth {
        static let minEthValue:Double=0.005
    }
    struct userToken {
      static let userTokenKey="user_token"
    }
    struct kycStatus {
    static let kycStatusKey="kyc_status"
    static let kycObjectKey="kyc_object"
    }
    struct pinValue {
        static let pinValueKey="pin_value"
    }
    struct loggedIn {
        static let loggedInKey="loggedIn"
    }
    
    struct kycStatusTypes {
         static let notStarted="NOT_STARTED"
         static let approved="ACCEPTED"
         static let pending="PENDING"
         static let rejected="REJECTED"
    }
    struct personalInfo {
        static let firstNameKey="first_name"
        static let middleNameKey="middle_name"
        static let lastNameKey="last_name"
        static let birthDayKey="birth_day"
        static let genderKey="gender"
        static let phoneCodeKey="phone_code"
        static let phoneNumberKey="phone_number"
    }
    struct ResidentialInfo {
        static let stateKey="state"
        static let cityKey="city"
        static let zipCodeKey="zip_code"
        static let address1Key="address_1"
        static let address2Key="address_2"
        static let countryCodeKey="country_code"
    }
    struct ProofOfIdentity {
        static let nationalityKey="nationality"
        static let typeOfDocumentKey="type_of_doc"
        static let docNumberKey="doc_number"
        static let expiryDateKey="expiry_date"
        static let frontImageKey="front_image"
        static let backImageKey="back_image"
        static let selfieImageKey="selfie_image"
    }
    struct InvestmentDetails {
        static let purposeOfActionsKey="purpose_of_actions"
        static let plannedRangesKey="planned_ranges"
        static let industyKey="industry"
        static let workTypeKey="work_type"
        static let purposeOfActionsValueKey="purpose_of_value_actions"
        static let plannedRangesValueKey="planned_value_ranges"
        static let industyValueKey="industry_value"
        static let workTypeValueKey="work_type_value"
        static let taxIdKey="tax_id"
    }
    struct Colors {
        static let ColorBrandPrimary = UIColorFromRGB(0x004A7C)    // previously BlockchainBlue
        static let ColorBrandSecondary = UIColorFromRGB(0x10ADE4)  // previously BlockchainLightBlue
        static let ColorBrandTertiary = UIColorFromRGB(0xB2D5E5)   // previously BlockchainLighterBlue
        static let ColorBrandQuaternary = UIColorFromRGB(0xDAF2FB) // previously BlockchainLightestBlue
        static let ColorError = UIColorFromRGB(0xCA3A3C)           // previously WarningRed
        static let ColorGray1 = UIColorFromRGB(0xEAEAEA)           // previously DisabledGray, SecondaryGray
        static let ColorGray2 = UIColorFromRGB(0xCCCCCC)           // previously TextFieldBorderGray
        static let ColorGray5 = UIColorFromRGB(0x545456)           // previously DarkGray
        static let ColorSent = UIColorFromRGB(0xF26C57)            // previously SentRed
        static let ColorSuccess = UIColorFromRGB(0x00A76F)         // previously SuccessGreen
    }
   
}
struct K {
    struct ProductionServer {
  //static let baseURL = "http://ec2-13-231-250-133.ap-northeast-1.compute.amazonaws.com/"
       static let baseURL = "https://www.odinwallet.io/"
    }
}

// MARK: Helper functions

func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )

}
