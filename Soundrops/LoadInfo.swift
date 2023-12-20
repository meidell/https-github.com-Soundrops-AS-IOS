import Foundation
import Alamofire
import AlamofireImage

class LoadInfo {
    
    var window: UIWindow?

    
    class func loadImages() {
        var j = 0
        while j <= 5 {
            j += 1
            Alamofire.request(d_cmp[String(j)+":sd_company_logo"] ?? "").responseImage { response in
                let image = response.result.value
                DispatchQueue.main.async {
                    let fileManager = FileManager.default
                    let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(String(j)+".sd_company_logo.jpg")
                    let imageData = image?.jpegData(compressionQuality: 0.5);
                    fileManager.createFile(atPath: imagePath as String, contents: imageData, attributes: nil)
                    d_cmp[String(j)+"sd_company_logo"] = String(imagePath)
                }
            }
        }
    }
    
    class func loadCampaign() {
        
        // modes...
        // 0:near = cmpid - counter: ord
        // 0:adds = cmpid - counter: ord
        // 0:map = cmpid - counter: co_map
        // 0:follow = cmpid - counter: co_fol
        // 0:near_category = category - counter: co_cat
        // 0:near:shopping = cmpid - counter: co_cac
       // d_me["sd_latitude"]="58.96"
      //  d_me["sd_longitude"]="5.75"
        
        
        let myurl: String  = "https://webservice.soundrops.com/REST_get_adds/3/"+d_me["sd_user_id"]!+"/"+d_me["sd_latitude"]!+"/"+d_me["sd_longitude"]!
        var co_fol: Int = 0
        var co_nct: Int = 1
        var co_act: Int = 1
        var co_map: Int = 0
        var mode:String = ""
        var category:String = ""
        var cmpid: String = ""
        var i: Int = 0
        var j: Int = 0
        var k: Int = 0
        var l: Int = 0
        d_oth.removeAll()
        d_lst.removeAll()
        d_cmp.removeAll()
        d_lst["0:adds:cg"]="All"
        d_lst["0:near:cg"]="All"
        d_oth["update"]="no"

        Alamofire.request(myurl).responseJSON { response in
            if let json = response.result.value {
                let JSON = json as! NSDictionary
                if JSON["data_result"] != nil {
                    let val : NSObject = JSON["data_result"] as! NSObject
                    let ok : Int = JSON["data_ok"] as! Int
                    if !(val.isEqual(NSNull())) && ok == 1  {
                        let JSON1 = JSON["data_result"] as! NSDictionary
                        var max:Int = 0
                        var value:Int = 0
                        for key in JSON1.allKeys {
                            value = Int(key as! String)!
                            if value > max {max=value}
                        }
                        
                        for order in 1001...max {
                            let JSON2 = JSON1[String(order)] as! NSDictionary
                            cmpid = String(JSON2["sd_cmp_id"] as! Int)
                            switch String(JSON2["sd_show_where"] as! Int) {
                            case "2":
                                mode = "near"
                                d_lst[String(j)+":n"]=cmpid
                                j+=1
                                d_lst["near:count"]=String(j)
                            case "3":
                                mode = "both"
                                d_lst[String(j)+":n"]=cmpid
                                j+=1
                                d_lst["near:count"]=String(j)
                                d_lst[String(i)+":a"]=cmpid
                                i+=1
                                d_lst["adds:count"]=String(i)
                            case "4":
                                mode = "community"
                                d_lst[String(k)+":community"]=cmpid
                                k+=1
                                d_lst["community:count"]=String(k)
                            default:
                                mode = "adds"
                                d_lst[String(i)+":a"]=cmpid
                                i+=1
                                d_lst["adds:count"]=String(i)
                            }
                            
                            // campaign info
                            d_cmp[cmpid+":sd_company_city"] = JSON2["sd_company_city"] as? String
                            d_cmp[cmpid+":sd_company_loc_lat"] = String(JSON2["sd_company_loc_lat"] as! Double)
                            d_cmp[cmpid+":sd_company_loc_lon"] = String(JSON2["sd_company_loc_lon"] as! Double)
                            d_cmp[cmpid+":sd_following"] = String(JSON2["following"] as! Bool)
                            d_cmp[cmpid+":sd_company_name"] = String(JSON2["sd_company_name"] as! String)
                            d_cmp[cmpid+":sd_distance"] = String(JSON2["distance"] as! Double)
                            d_cmp[cmpid+":sd_cmp_date_start"] = String(JSON2["sd_cmp_date_start"] as! String)
                            d_cmp[cmpid+":sd_cmp_headline"] = String(JSON2["sd_cmp_headline"] as! String)
                            d_cmp[cmpid+":sd_cmp_id"] = String(JSON2["sd_cmp_id"] as! Int)
                            
                            d_cmp[cmpid+":sd_cmp_exclusive"] = String(JSON2["sd_cmp_exclusive"] as! Bool)
                            d_cmp[cmpid+":sd_cmp_video"] = String(JSON2["sd_cmp_video"] as! Bool)
                            d_cmp[cmpid+":sd_cmp_video_stream"] = String(JSON2["sd_cmp_video_stream"] as! String)

                            d_cmp[cmpid+":sd_comp_contact"] = String(JSON2["sd_comp_contact"] as! Int)
                            d_cmp[cmpid+":sd_company_business_model"] = String(JSON2["sd_company_business_model"] as! Int)
                            d_cmp[cmpid+":sd_company_business_category_name"] = String(JSON2["sd_company_business_category_name"] as! String)
                            d_cmp[cmpid+":sd_company_business_sub_category_name"] = String(JSON2["sd_company_business_sub_category_name"] as! String)
                            d_cmp[cmpid+":sd_cmp_image"] = String(JSON2["sd_cmp_image"] as! String)
                            d_cmp[cmpid+":sd_cmp_text"] = String(JSON2["sd_cmp_text"] as! String)
                            d_cmp[cmpid+":sd_cmp_voucher_code"] = String(JSON2["sd_cmp_voucher_code"] as! Int)
                            d_cmp[cmpid+":sd_cmp_voucher_desc"] = String(JSON2["sd_cmp_voucher_desc"] as! String)
                            d_cmp[cmpid+":sd_cmp_voucher_discount"] = String(JSON2["sd_cmp_voucher_discount"] as! Double)
                            d_cmp[cmpid+":sd_cmp_voucher_url"] = String(JSON2["sd_cmp_voucher_url"] as! String)
                            d_cmp[cmpid+":shareString"] = String(JSON2["shareString"] as! String)
                            d_cmp[cmpid+":sd_cmp_updated"] = String(JSON2["sd_cmp_updated"] as! Int)
                            d_cmp[cmpid+":sd_company_id"] = String(JSON2["sd_company_id"] as! Int)
                            d_cmp[cmpid+":sd_company_logo"] = String(JSON2["sd_company_logo"] as! String)
                            
                            let mystring1 = String(JSON2["sd_company_logo"] as! String)
                            let replace1 = mystring1.replacingOccurrences(of: "soundrops.no", with: "site.soundrops.com")
                            let mystring = String(JSON2["sd_cmp_image"] as! String)
                            let replace = mystring.replacingOccurrences(of: "soundrops.no", with: "site.soundrops.com")
                            d_cmp[cmpid+":sd_cmp_image"] = replace
                            d_cmp[cmpid+":sd_company_logo"] = replace1
                            
                            d_cmp[cmpid+":sd_company_postcode"] = String(JSON2["sd_company_postcode"] as! String)
                            d_cmp[cmpid+":sd_company_street"] = String(JSON2["sd_company_street"] as! String)
                            d_cmp[cmpid+":used_voucher"] = String(JSON2["used_voucher"] as! Bool)
                            d_cmp[cmpid+":foreign_call_to_action"] = String(JSON2["foreign_call_to_action"] as! Int)
                            d_cmp[cmpid+":sd_show_cmp"] = String(JSON2["sd_show_cmp"] as! Bool)
                            
                            //filter on follows
                            if d_cmp[cmpid+":sd_following"]! == "true"  {
                                d_lst[String(co_fol)+":follow"]=cmpid
                                co_fol+=1
                                d_lst["follow:count"]=String(co_fol)
                            }
                            //filter on map
                            if d_cmp[cmpid+":sd_company_business_model"]! != "2" &&  (d_cmp[cmpid+":sd_show_cmp"]! == "true" || mode=="near" || mode=="both")  && String(JSON2["sd_show_where"] as! Int) != "4" {
                                d_lst[String(co_map)+":map"]=cmpid
                                co_map+=1
                                d_lst["map:count"]=String(co_map)
                                
                            }
                            //filter on categories
                            category = JSON2["sd_company_business_category_name"] as! String
                            //category list
                            if (mode=="adds" || mode=="both") && d_cmp[cmpid+":sd_show_cmp"]! == "true" {
                                if d_oth["adds:"+category]==nil {
                                    d_oth["adds:"+category]="1"
                                    d_lst[String(co_act)+":adds:cg"]=category
                                    co_act+=1
                                    d_lst["adds:cg:count"]=String(co_act)
                                    d_lst["0:adds:"+category]=cmpid
                                    d_oth[category+":adds"]="1"
                                    d_lst["adds:"+category+":count"]=d_oth[category+":adds"]
                                } else {
                                    d_lst[d_oth[category+":adds"]!+":adds:"+category]=cmpid
                                    let i = Int(d_oth[category+":adds"]!)!+1
                                    d_oth[category+":adds"]=String(i)
                                    d_lst["adds:"+category+":count"]=d_oth[category+":adds"]!                                }
                            }
                            if mode=="near" || mode=="both" {
                                if d_oth["near:"+category]==nil {
                                    d_oth["near:"+category]="1"
                                    d_lst[String(co_nct)+":near:cg"]=category
                                    co_nct+=1
                                    d_lst["near:cg:count"]=String(co_nct)
                                    d_lst["0:near:"+category]=cmpid
                                    d_oth[category+":near"]="1"
                                    d_lst["near:"+category+":count"]=d_oth[category+":near"]
                                    
                                } else {
                                    d_lst[d_oth[category+":near"]!+":near:"+category]=cmpid
                                    let i = Int(d_oth[category+":near"]!)!+1
                                    d_oth[category+":near"]=String(i)
                                    d_lst["near:"+category+":count"]=d_oth[category+":near"]!
                                }
                            }
                        }
                        // near
                        k = 2
                        i = 0
                        l = 0
                        if d_lst["community:count"] == nil {d_lst["community:count"]="0"}
                        if d_lst["near:count"] == nil {d_lst["community:count"]="0"}
                        if d_lst["near:count"] == nil {d_lst["near:count"]="0"}
                        j = Int(d_lst["community:count"]!)!
                        var mycount:Int = Int(d_lst["near:count"]!)! - 1
                        var distances:[Double] = []
                        var mycamps:[Int] = []
                        
                        if mycount > -1 {
                            for order in 0...mycount {
                                distances.append(Double(d_cmp[d_lst[String(order)+":n"]!+":sd_distance"]!)!)
                                if order == k && l < j {
                                    d_lst[String(i)+":near"] = d_lst[String(l)+":community"]!
                                    mycamps.append(i)
                                    
                                    i+=1
                                    k+=5
                                    l+=1
                                }
                                d_lst[String(i)+":near"] = d_lst[String(order)+":n"]!
                                i+=1
                            }
                            d_lst["near:count"] = String(Int(d_lst["near:count"]!)!+l)
                            distances = distances.sorted()
                            l-=1
                            k=2
                            if l > -1 {
                                for order in 0...l {
                                    d_cmp[d_lst[String(order)+":community"]!+":sd_distance"] = String(distances[k])
                                    k+=5
                                    
                                }
                            }
                        }
                        
                        
                        //for
                        k = 2
                        i = 0
                        l = 0
                        if d_lst["adds:count"] == nil {d_lst["adds:count"]="0"}
                        mycount = Int(d_lst["adds:count"]!)! - 1
                        
                        if mycount > -1 {
                            for order in 0...mycount {
                                if order == k && l < j {
                                    d_lst[String(i)+":adds"] = d_lst[String(l)+":community"]!
                                    
                                    i+=1
                                    k+=5
                                    l+=1
                                }
                                d_lst[String(i)+":adds"] = d_lst[String(order)+":a"]!
                                i+=1
                            }
                            
                            d_lst["adds:count"] = String(Int(d_lst["adds:count"]!)!+l)
                            
                        }
                        
                    }
                    
                }
               
            }
            
        }
    }
    
    

}
