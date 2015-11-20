/* 
  jsCore.js
  JSToOCDemo

  Created by Harry on 15/11/20.
  Copyright © 2015年 HarryDeng. All rights reserved.
*/

function max(a, b){
    return a>b?a:b;
}


function callBack(a, b){
    var paramters = postParamters(20, 18); //执行OC的postParamters方法
    var par1 = paramters['paramter1'];
    var par2 = paramters['paramter2'];
    paramters['paramter1'] = par1 + a;
    paramters['paramter2'] = par2 + b;
    return paramters;
}

