(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["dashboard"],{"20fc":function(t,a,s){"use strict";var e=s("9a50"),d=s.n(e);d.a},2527:function(t,a,s){},"2f0a":function(t,a,s){"use strict";var e=s("2527"),d=s.n(e);d.a},7277:function(t,a,s){"use strict";s.r(a);var e=function(){var t=this,a=t.$createElement,s=t._self._c||a;return s("div",{staticClass:"page page--dashboard"},[t.showLoadingState||t.showEmptyState?t._e():s("div",{staticClass:"page--dashboard__cards"},t._l(t.standards,(function(t){return s("Standard",{key:t.id,attrs:{standard:t,label:"Standard"}})})),1),t.showLoadingState?s("div",{staticClass:"page--dashboard__state--loading"},[s("Loading")],1):t._e(),t.showEmptyState?s("div",{staticClass:"page--dashboard__state--empty"},[s("div",{staticClass:"page--dashboard__state--empty__description"},[s("span",[t._v("No standards found ")]),t.selectedOccupation?s("span",[t._v("for occupation:")]):t._e(),t.selectedOccupation?s("div",{staticClass:"page--dashboard__state--empty__description__occupation"},[t._v(t._s(t.selectedOccupation.title))]):t._e()]),s("div",{staticClass:"page--dashboard__state--empty__action"},[t._v(" Please try searching for a different occupation ")]),t.selectedOccupation?s("div",{staticClass:"page--dashboard__state--empty__button button button--link",on:{click:t.clearSelectedOccupation}},[t._v(" Clear selected occupation ")]):t._e()]):t._e()])},d=[],r=(s("a4d3"),s("4de4"),s("4160"),s("e439"),s("dbb4"),s("b64b"),s("159b"),s("2fa7")),n=s("2f62"),o=function(){var t=this,a=t.$createElement,s=t._self._c||a;return s("router-link",{staticClass:"standard",attrs:{to:t.routerLink}},[s("div",{staticClass:"standard__label"},[t._v(t._s(t.label))]),s("div",{staticClass:"standard__logo"},[s("img",{staticClass:"standard__logo__logo",attrs:{src:t.standard.organization.logoUrl,alt:t.standard.organizationTitle}})]),s("div",{staticClass:"standard__occupation-name"},[t._v(t._s(t.standard.title))]),s("div",{staticClass:"standard__occupation-metadata"},[s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__type"},[t._v(t._s(t.standard.occupation.kind))]),s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__onet"},[t._v(t._s(t.standard.occupation.onetCode||"ONET"))]),s("div",{staticClass:"standard__occupation-metadata__item standard__occupation-metadata__cb"},[t._v(t._s(t.standard.occupation.rapidsCode||"Rapid"))])]),s("div",{staticClass:"standard__divider--stats"}),s("div",{staticClass:"standard__work-process-data"},[s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.standard.workProcesses.length))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Work")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Processes")])]),s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.standard.totalNumberOfSkills))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Skills")])]),s("div",{staticClass:"standard__work-process-data__stat"},[s("div",{staticClass:"standard__work-process-data__stat__number"},[t._v(t._s(t.standard.totalNumberOfHours))]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Total")]),s("div",{staticClass:"standard__work-process-data__stat__text"},[t._v("Hours")])])])])},c=[],_=s("e589"),i=s.n(_),l={props:{standard:Object,label:String},data:function(){return{ICON_LEFT_NAV_HEART:i.a}},computed:{routerLink:function(){return{name:"standard",params:{id:this.standard.id}}}}},p=l,u=(s("2f0a"),s("2877")),v=Object(u["a"])(p,o,c,!1,null,"59847f95",null),b=v.exports,f=s("3a5e");function m(t,a){var s=Object.keys(t);if(Object.getOwnPropertySymbols){var e=Object.getOwnPropertySymbols(t);a&&(e=e.filter((function(a){return Object.getOwnPropertyDescriptor(t,a).enumerable}))),s.push.apply(s,e)}return s}function C(t){for(var a=1;a<arguments.length;a++){var s=null!=arguments[a]?arguments[a]:{};a%2?m(s,!0).forEach((function(a){Object(r["a"])(t,a,s[a])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(s)):m(s).forEach((function(a){Object.defineProperty(t,a,Object.getOwnPropertyDescriptor(s,a))}))}return t}var g={name:"dashboard",components:{Standard:b,Loading:f["a"]},methods:{clearSelectedOccupation:function(){this.$store.dispatch("occupations/setSelectedOccupation")}},computed:C({},Object(n["b"])({showEmptyState:"standards/standardsListEmptyAndNotLoading"}),{},Object(n["c"])({selectedOccupation:function(t){return t.occupations.selectedOccupation},showLoadingState:function(t){return t.standards.loading},standards:function(t){return t.standards.list}}))},O=g,w=(s("20fc"),Object(u["a"])(O,e,d,!1,null,"ab46eea0",null));a["default"]=w.exports},"9a50":function(t,a,s){}}]);
//# sourceMappingURL=dashboard.63d752f8.js.map