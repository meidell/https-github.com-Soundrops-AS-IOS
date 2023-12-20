class Campaign {
    var id: Int?
    var startText: String?
    var endText: String?
    var callToActionOne: String?
    var imageUrl: String?
    var contactType: String?
    var voucherText: String?
    var voucherDiscount: String?
    var campaignUrl: String?
    var website: String?
    var category: String?
    var startDate: String?
    var latitude: Double?
    var longitude: Double?
    var follow: String?
    var companyName: String?
    var voucherUsed: Int?
    
    init(id: Int?, startText: String?, endText: String?, callToAction1: String?, imageUrl: String?, contactType: String?, voucherUsed: Int?, voucherDiscount: String?, voucherText: String?, campaignUrl: String?, website: String?, category: String?, startDate: String?, latitude: Double?, longitude: Double?, follow: String?, companyName: String?) {
        self.id = id
        self.startText = startText
        self.endText = endText
        self.callToActionOne = callToAction1
        self.imageUrl = imageUrl
        self.voucherUsed = voucherUsed
        self.voucherText = voucherText
        self.voucherDiscount = voucherDiscount
        self.contactType = contactType
        self.campaignUrl = campaignUrl
        self.website = website
        self.category = category
        self.startDate = startDate
        self.latitude = latitude
        self.longitude = longitude
        self.follow = follow
        self.companyName = companyName
        
    }
}

