//
//  MRest.swift
//  Lulla
//
//  Created by Mac on 2017. 12. 1..
//  Copyright © 2017년 Mac. All rights reserved.
//

import UIKit
import Alamofire

extension MRest {

	struct UI {
		var loadingInView: ILoadingView?
	}
	
	struct Sender {
        enum URLType {
            case base
            case empty
        }

		var path: Path
		var method: HTTPMethod
		var parameters: Parameters
		var object: JSONEncodable?
		
		var encoding: ParameterEncoding?
		
        var customUrl: URLConvertible?
    
        var urlType: URLType = .base
        
		var url: URLConvertible {
            
            if let url = customUrl {
                return url
            }

            switch urlType {
            case .base:
                return PPCST.Rest.baseURL + PPCST.Rest.apiUri + path.rawValue
            case .empty:
                return PPCST.Rest.baseURL + "/" + path.rawValue
            }
        }
		
		var ui = UI()
		
		var debugLog = true
		
        init(path: Path, urlType:URLType = .base, method: HTTPMethod = .post, parameters: Parameters = Parameters(), object: JSONEncodable? = nil, encoding: ParameterEncoding? = nil) {
            self.urlType = urlType
			self.path = path
			self.method = method
			self.parameters = parameters
			self.object = object
			self.encoding = encoding
		}
	}
	
	struct Resp <T> {
		var code: Code
		var message: String
		var object: T
        var dic: Dictionary<String, Any>?
        var array: Array<[String:Any]>?
	}
	
}

class MRest {
	
	static let shared = MRest()
	
	lazy var manager: SessionManager = {
		let configuration = URLSessionConfiguration.default
		configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
		configuration.timeoutIntervalForRequest = Double(10)
		//configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		//return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: MServerTrustPolicyManager())
		return Alamofire.SessionManager(configuration: configuration)
	}()
	
	@discardableResult func request<T>(_ sender: Sender, handler: ((Resp<T>) -> Void)? = nil) -> DataRequest where T: NABase {
		var headers = HTTPHeaders()
        
        if sender.path != MRest.Path.login {
            if MData.shared.accessToken?.count ?? 0 > 0 {
                headers["Authorization"] = MData.shared.accessToken
            }
        }


		
        /*
         encoding: JSONEncoding.default,
         headers: ["Content-Type": "application/json; charset=utf-8",
                   "x-onul-auth-token": "onulhoi",
                   "Authorization": MData.shared.accessToken!])

             if let encoding = sender.encoding {
                 info.encoding = encoding
             }
         */
        
		var info = { () -> (parameters: Parameters, encoding: ParameterEncoding) in
			if let jsonObject = sender.object?.toJson() {
				return (parameters: jsonObject, encoding: JSONEncoding.default)
			} else {
//                return (parameters: sender.parameters, encoding: URLEncoding.default)
				return (parameters: sender.parameters, encoding: JSONEncoding.default)
			}
		}()
		
		if let encoding = sender.encoding {
			info.encoding = encoding
		}
        
        if sender.urlType == .base {
            headers["x-onul-auth-token"] = "onulhoi"
        }
//        let urlString = try? sender.url.asURL().absoluteString
//        if let urlString = urlString {
//            if urlString.contains("/partner/api") {
//                headers["x-onul-auth-token"] = "onulhoi"
//            } else {
//                headers.removeValue(forKey: "x-onul-auth-token")
//            }
//        }

        print(sender.parameters.count)

        SVProgressHUD.show()
        
        let req = manager.request(sender.url,
                                  method: sender.method,
                                  parameters: sender.parameters.count > 0 ? info.parameters : nil,
                                  encoding: info.encoding,
                                  headers: headers)
        req.validate()
        req.responseJSON { (response) in
            var code: Code = .none
            var message = ""
            let object = T(value: response.result.value)
            
            //            let str = String(decoding: response.data!, as: UTF8.self)
            //            print(str)
            //
            //            do{
            //                if let data = response.data {
            //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            //                    print(json)
            //                }
            //            } catch {
            //                print("erroMsg")
            //            }
            
            //            guard let result = response.data else {return}
            //            do {
            //                let decoder = JSONDecoder()
            //                let json = try decoder.decode(NDLogin.self, from: result)
            //                print(json.message)
            //                //                if json.result == 2000{ completion(json.data)
            //                //
            //                //                }
            //
            //            } catch { print("error!\(error)")
            //
            //            }
            
//            do{
//                if let data = response.data {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                    let rep2: Dictionary? = json?["operationInventoryCountResponse"] as? Dictionary<String, Any>
//                    let rep3 = rep2?["totalCountForMain"] as? Dictionary<String, Int>
//                    print(rep3?.keys)
//                    print(rep3?.values)
//
//                }
//            } catch {
//                print("erroMsg")
//            }

            
            defer {
                SVProgressHUD.dismiss()
                
                do{
                    if let data = response.data {
                        let json = try JSONSerialization.jsonObject(with: data)
                        if let jsonArray = json as? [[String:Any]] {
                            handler?(Resp(code: code, message: message, object: object, dic: nil, array: jsonArray))
                        } else if let jsonDictionary = json as? [String:Any] {
                            handler?(Resp(code: code, message: message, object: object, dic: jsonDictionary, array: nil))
                        } else {
                            handler?(Resp(code: code, message: message, object: object, dic: nil, array: nil))
                        }
                    }
                } catch {
                    handler?(Resp(code: code, message: message, object: object, dic: nil, array: nil))
                }
            }
            
            let successed = response.response?.statusCode == 200
            
            if sender.debugLog {
                if __DD__.LOG.NET_Response_Show {
                    if successed {
                        NETLog("[Response] \(req) \(sender.parameters.prettyDescription) \(response)")
                    } else {
                        NETLog("[Response] \(req) \(sender.parameters.prettyDescription) \(response) (\(object.resultCode))")
                    }
                } else {
                    NETLog("[Response] \(req) \(sender.parameters.prettyDescription) \(response.result)")
                }
            }
            
//            let statusCode = response.response?.statusCode
//            if statusCode == 200 {
//                
//            }
            switch response.result {
            case .success(_):
                if successed {
                    code = .success
                    if let appResultMessage = object.appResultMessage {
                        message = appResultMessage
                    }
                } else {
                    let restApiCodeKey = "restApi.code.\(object.resultCode)"
                    let restApiCodeText = HSTR(restApiCodeKey)
                    
                    if let appResultMessage = object.appResultMessage {
                        message = appResultMessage
                    } else {
                        message = (restApiCodeKey != restApiCodeText) ? restApiCodeText : "\(object.resultCode)"
                    }
                    
                    code = .errServer
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        PPAlert.present(title: message)
                    }
                }
            case .failure(let error):
                //리스펀스 구조가 이상해서 따로 처리함
                if successed {
                    code = .success
                } else {
                    code = .errNetwork
                    
                    switch error._code {
                    case NSURLErrorNotConnectedToInternet:
                        message = HSTR("restApi.code.notConnected")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            PPAlert.present(title: message)
                        }
                    case NSURLErrorTimedOut:
                        message = HSTR("restApi.code.generalError")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            PPAlert.present(title: message)
                        }
                    default:
                        //message = error.localizedDescription
                        guard let result = response.data else {return}
                        do {
                            let decoder = JSONDecoder()
                            let json = try decoder.decode(NDError.self, from: result)
                            print(json.message as Any)
                            message = json.message ?? HSTR("restApi.code.generalError")
                        } catch {
                            print("error!\(error)")
                        }
                        
                        //                        message = HSTR("restApi.code.generalError")
                        print("error.localizedDescription: \(error.localizedDescription)")
                    }
                }
            }
        }

		if sender.debugLog {
			if __DD__.LOG.NET_RequestHeader_Show {
				NETLog("[Request] \(req)\n     (Header) \(String(describing: req.request?.allHTTPHeaderFields)) \n     (Body) \(info.parameters.prettyDescription)")
			} else {
				NETLog("[Request] \(req) \(info.parameters.prettyDescription)")
			}
		}

		return req
	}
	
}
