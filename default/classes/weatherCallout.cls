public with sharing class weatherCallout {

    //getデータ格納用変数
    public string pubOffice {get; set;}       //発表元
    public datetime reportDateTime {get; set;}    //発表日時
    public string targetArea{get; set;}          //地域
    public string headlineText{get; set;}        //
    public string description{get; set;}         //詳細
    public string prefecture{get;set;}          //表示都道府県
    
    public weatherCallout() {

        this.prefecture = '260000';

    }

    public void getWeather(){

        Boolean intent_status = false;
        Integer statusCode;
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HttpResponse res = new HttpResponse();

        // httpリクエスト設定
        //String API_KEY = '';
        //Blob headerVal = Blob.valueOf(API_KEY + ':');
        //String authorizationHeader = 'Bearer' + API_KEY;
        String SETUP_INTENT_URL = 'https://www.jma.go.jp/bosai/forecast/data/overview_forecast/';
        String sendUrl = SETUP_INTENT_URL + prefecture + '.json';

        req.setEndpoint(sendUrl);
        req.setTimeout(60000);
        req.setMethod('GET');

        res = http.send(req);
        statusCode = res.getStatusCode();

        if(statusCode != 200){
            System.debug('エラーによりレコードを取得できません。　ステータスコード：'+ statusCode);
        }else{
            System.debug('レコードを取得しました');
            System.debug(res.getBody());
    
            JSONParser parser = JSON.CreateParser(res.getBody());
            while (parser.nextToken() != null) {
                System.debug('ラベル名'+parser.getText());
                if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                    System.debug('スタートオブジェクト');
                    parser.nextToken();
                    if(parser.getText()=='publishingOffice'){
                        parser.nextToken();
                        pubOffice = parser.getText();
                        parser.nextToken();
                        if(parser.getText()=='reportDatetime'){
                            parser.nextToken();
                            reportDateTime = parser.getDateTimeValue();
                            parser.nextToken();
                            if(parser.getText()=='targetArea'){
                                parser.nextToken();
                                targetArea = parser.getText();
                                parser.nextToken();
                                if(parser.getText()=='headlineText'){
                                    parser.nextToken();
                                    headlineText = parser.getText();
                                    parser.nextToken();
                                    if(parser.getText()=='text'){
                                        parser.nextToken();
                                        description = parser.getText();
                                        parser.nextToken();
                                    }
                                }
                            }
                        }
                    }
                }
                System.debug(
                    'pubOffice:'+pubOffice+
                    'reportDateTime:'+reportDateTime+
                    'targetArea:'+targetArea+
                    'headlineText:'+headlineText+
                    'description:'+description
                    );
                parser.nextToken();
            }
    
        }      
    }


}
