//
//  JSUserSripts.swift
//  MIACRMiPad
//
//  Created by Danik on 29.12.22.
//

import Foundation

let setDataL  = """
var swiftIdBan = document.querySelector('.startBoxBanner').id;
var swiftSceneElm = document.querySelector('#'+swiftIdBan+'> .HYPE_scene[style*="block"]');
document.addEventListener('click', (e)=>{
    console.log(e.target)
    if(e.target.classList.contains('btn-login')){
        localStorage.setItem("datalcrm", btoa(swiftSceneElm.querySelector('.login-email').value));
        localStorage.setItem("datapcrm", btoa(swiftSceneElm.querySelector('.login-password').value));
    }
})
"""

let getDataL  = """
var ll = localStorage.getItem('datalcrm');
var pp = localStorage.getItem('datapcrm');
var swiftIdBan = document.querySelector('.startBoxBanner').id;
var swiftSceneElm = document.querySelector('#'+swiftIdBan+'> .HYPE_scene[style*="block"]');
swiftSceneElm.querySelector('.login-email').value = atob(ll);
swiftSceneElm.querySelector('.login-password').value = atob(pp);
document.getElementById('triggerAppKey').value="macOS";
"""

