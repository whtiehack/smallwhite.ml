---
title: 让MFC的 WebBrowser 控件 使用IE8或以上的内核(默认是IE7) 并且使用IE按钮样式
date: 2011-08-28 00:39:32
tags: CSDN迁移
---
   完全不熟悉web方面的东西 

 方法都是网上找的 具体出处没有记录

 

 首先 让WebBrowser 使用 IE8或以上的内核

 

 


```
void WINAPI WriteWebBrowserRegKey(LPCTSTR lpKey,DWORD dwValue)
{
	HKEY hk;
	CString str = "Software\\Microsoft\\Internet Explorer\\Main\\FeatureControl\\";
	str += lpKey;
	if (RegCreateKey(HKEY_LOCAL_MACHINE,str,&hk)!=0)
	{
		MessageBox(NULL,"打开注册表失败!","Error",0);
		ExitProcess(-1);
	}
	if (RegSetValueEx(hk,"你的exe名称.exe",NULL,REG_DWORD,(const byte*)&dwValue,4)!=0)
	{
		RegCloseKey(hk);
		MessageBox(NULL,"写注册表失败!","Error",0);
		ExitProcess(-1);
	}
	RegCloseKey(hk);
}
```
  
  
在 InitInstance()内

 


```
		WriteWebBrowserRegKey("FEATURE_BROWSER_EMULATION",9000);
	//	WriteWebBrowserRegKey("FEATURE_ACTIVEX_REPURPOSEDETECTION",1);
		WriteWebBrowserRegKey("FEATURE_BLOCK_LMZ_IMG",1);
		WriteWebBrowserRegKey("FEATURE_BLOCK_LMZ_OBJECT",1);
		WriteWebBrowserRegKey("FEATURE_BLOCK_LMZ_SCRIPT",1);
		WriteWebBrowserRegKey("FEATURE_Cross_Domain_Redirect_Mitigation",1);
		WriteWebBrowserRegKey("FEATURE_ENABLE_SCRIPT_PASTE_URLACTION_IF_PROMPT",1);
		WriteWebBrowserRegKey("FEATURE_LOCALMACHINE_LOCKDOWN",1);
		WriteWebBrowserRegKey("FEATURE_GPU_RENDERING",1);
```
  
  


 

 下面是让WebBrowser 使用ie的风格 具体这个应该怎么称呼.不懂 -_-! 总之按钮样式不再是丑陋的 2000经典样式了

 

 增加一个头文件

 


```

	// class name: CWebUIController  WebUIController.h 源代码： 
	// author:     Dandy Cheung
	// email:      dandycheung@21cn.com
	// date:       2005-3-18

#ifndef __WEBUICONTROLLER_H__
#define __WEBUICONTROLLER_H__
#
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include <MSHTMHST.H>
#include <EXDISP.H>
#include <EXDISPID.H>

	inline 
	HRESULT _CoAdvise(IUnknown* pUnkCP, IUnknown* pUnk, const IID& iid, LPDWORD pdw)
{
	IConnectionPointContainer* pCPC = NULL;
	IConnectionPoint* pCP = NULL;
	HRESULT hRes = pUnkCP->QueryInterface(IID_IConnectionPointContainer, (void**)&pCPC);
	if(SUCCEEDED(hRes) && pCPC != NULL)
	{
		hRes = pCPC->FindConnectionPoint(iid, &pCP);
		if(SUCCEEDED(hRes) && pCP != NULL)
		{
			hRes = pCP->Advise(pUnk, pdw);
			pCP->Release();
		}

		pCPC->Release();
	}

	return hRes;
}

inline 
	HRESULT _CoUnadvise(IUnknown* pUnkCP, const IID& iid, DWORD dw)
{
	IConnectionPointContainer* pCPC = NULL;
	IConnectionPoint* pCP = NULL;
	HRESULT hRes = pUnkCP->QueryInterface(IID_IConnectionPointContainer, (void**)&pCPC);
	if(SUCCEEDED(hRes) && pCPC != NULL)
	{
		hRes = pCPC->FindConnectionPoint(iid, &pCP);
		if(SUCCEEDED(hRes) && pCP != NULL)
		{
			hRes = pCP->Unadvise(dw);
			pCP->Release();
		}

		pCPC->Release();
	}

	return hRes;
}

class CWebUIController : public DWebBrowserEvents2, public IDocHostUIHandler
{
	ULONG m_uRefCount;
	
	IWebBrowser2* m_pWebBrowser2;
	DWORD m_dwCookie;

	BOOL m_bEnable3DBorder;
	BOOL m_bEnableScrollBar;

public:
	CWebUIController() : m_uRefCount(0), m_pWebBrowser2(NULL), m_dwCookie(0)
	{
		m_bEnable3DBorder = TRUE;
		m_bEnableScrollBar = TRUE;
	}

	virtual ~CWebUIController()
	{
	}
public:
	// IUnknown Methods
	STDMETHOD(QueryInterface)(REFIID riid, void** ppvObject)
	{
		*ppvObject = NULL;

		if(IsEqualGUID(riid, DIID_DWebBrowserEvents2) ||
			IsEqualGUID(riid, IID_IDispatch))
		{
			*ppvObject = (DWebBrowserEvents2*)this;
			AddRef();
			return S_OK;
		}
		else if(IsEqualGUID(riid, IID_IDocHostUIHandler) ||
			IsEqualGUID(riid, IID_IUnknown))
		{
			*ppvObject = (IDocHostUIHandler*)this;
			AddRef();
			return S_OK;
		}

		return E_NOINTERFACE;
	}

	STDMETHOD_(ULONG, AddRef)(void)
	{
		m_uRefCount++;
		return m_uRefCount;
	}

	STDMETHOD_(ULONG, Release)(void)
	{
		m_uRefCount--;
		ULONG uRefCount = m_uRefCount;
		if(uRefCount == 0)
			delete this;

		return uRefCount;
	}

	// IDispatch Methods
	STDMETHOD(GetTypeInfoCount)(unsigned int FAR* pctinfo)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(GetTypeInfo)(UINT itinfo, LCID lcid, ITypeInfo** pptinfo)        
	{
		return E_NOTIMPL;
	}


	STDMETHOD(GetIDsOfNames)(REFIID riid, OLECHAR FAR* FAR* rgszNames, 
		unsigned int cNames, LCID lcid, DISPID FAR* rgDispId)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(Invoke)(DISPID dispidMember,REFIID riid, LCID lcid, WORD wFlags,
		DISPPARAMS* pDispParams, VARIANT* pvarResult,
		EXCEPINFO* pexcepinfo, UINT* puArgErr)
	{
		if(!pDispParams)
			return E_INVALIDARG;

		switch(dispidMember)
		{
			//
			// The parameters for this DISPID are as follows:
			// [0]: URL to navigate to - VT_BYREF|VT_VARIANT
			// [1]: An object that evaluates to the top-level or frame
			//      WebBrowser object corresponding to the event. 
		case DISPID_NAVIGATECOMPLETE2:

			//
			// The IDocHostUIHandler association must be set
			// up every time we navigate to a new page.
			//
			if(pDispParams->cArgs >= 2 && pDispParams->rgvarg[1].vt == VT_DISPATCH)
				SetCustomDoc(pDispParams->rgvarg[1].pdispVal);
			else
				return E_INVALIDARG;

			break;

		default:
			break;
		}

		return S_OK;
	}

	// IDocHostUIHandler Methods
protected:
	STDMETHOD(ShowContextMenu)(DWORD dwID, POINT FAR* ppt, IUnknown FAR* pcmdtReserved,
		IDispatch FAR* pdispReserved)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(GetHostInfo)(DOCHOSTUIINFO FAR* pInfo)
	{
		if(pInfo != NULL)
		{
			pInfo->dwFlags |= (m_bEnable3DBorder ? 0 : DOCHOSTUIFLAG_NO3DBORDER);
			pInfo->dwFlags |= (m_bEnableScrollBar ? 0 : DOCHOSTUIFLAG_SCROLL_NO);
			pInfo->dwFlags |=DOCHOSTUIFLAG_THEME; //这里是我自己添加的 让其使用IE的按钮风格
		}

		return S_OK;
	}

	STDMETHOD(ShowUI)(DWORD dwID, IOleInPlaceActiveObject FAR* pActiveObject,
		IOleCommandTarget FAR* pCommandTarget,
		IOleInPlaceFrame  FAR* pFrame,
		IOleInPlaceUIWindow FAR* pDoc)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(HideUI)(void)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(UpdateUI)(void)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(EnableModeless)(BOOL fEnable)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(OnDocWindowActivate)(BOOL fActivate)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(OnFrameWindowActivate)(BOOL fActivate)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(ResizeBorder)(LPCRECT prcBorder, IOleInPlaceUIWindow FAR* pUIWindow,
		BOOL fRameWindow)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(TranslateAccelerator)(LPMSG lpMsg, const GUID FAR* pguidCmdGroup,
		DWORD nCmdID)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(GetOptionKeyPath)(LPOLESTR FAR* pchKey, DWORD dw)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(GetDropTarget)(IDropTarget* pDropTarget,
		IDropTarget** ppDropTarget)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(GetExternal)(IDispatch** ppDispatch)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(TranslateUrl)(DWORD dwTranslate, OLECHAR* pchURLIn,
		OLECHAR** ppchURLOut)
	{
		return E_NOTIMPL;
	}

	STDMETHOD(FilterDataObject)(IDataObject* pDO, IDataObject** ppDORet)
	{
		return E_NOTIMPL;
	}

public:
	HRESULT SetWebBrowser(IWebBrowser2* pWebBrowser2)
	{
		// Unadvise the event sink, if there was a
		// previous reference to the WebBrowser control.
		if(m_pWebBrowser2)
		{
			_CoUnadvise(m_pWebBrowser2, DIID_DWebBrowserEvents2, m_dwCookie);
			m_dwCookie = 0;
			// _CoUnadvise中就已经被Release         //  m_pWebBrowser2->Release();
		}

		m_pWebBrowser2 = pWebBrowser2;
		if(pWebBrowser2 == NULL)
			return S_OK;

		m_pWebBrowser2->AddRef();

		return _CoAdvise(m_pWebBrowser2, (IDispatch*)this, DIID_DWebBrowserEvents2, &m_dwCookie);
	}

	void Enable3DBorder(BOOL bEnable = TRUE)
	{
		m_bEnable3DBorder = bEnable;
	}

	void EnableScrollBar(BOOL bEnable = TRUE)
	{
		m_bEnableScrollBar = bEnable;
	}

private:
	void SetCustomDoc(LPDISPATCH lpDisp)
	{
		if(lpDisp == NULL)
			return;

		IWebBrowser2* pWebBrowser2 = NULL;
		HRESULT hr = lpDisp->QueryInterface(IID_IWebBrowser2, (void**)&pWebBrowser2);

		if(SUCCEEDED(hr) && pWebBrowser2)
		{
			IDispatch* pDoc = NULL;
			hr = pWebBrowser2->get_Document(&pDoc);

			if(SUCCEEDED(hr) && pDoc)
			{
				ICustomDoc* pCustDoc = NULL;
				hr = pDoc->QueryInterface(IID_ICustomDoc, (void**)&pCustDoc);
				if(SUCCEEDED(hr) && pCustDoc != NULL)
				{
					pCustDoc->SetUIHandler(this);
					pCustDoc->Release();
				}

				pDoc->Release();
			}

			pWebBrowser2->Release();
		}
	}
};

#endif // __WEBUICONTROLLER_H__

```
  
  


 在 Dlg类里添加一个变量

 

 


```
CWebUIController * m_webUICtrl;
```
  
  
在 Dlg的 OnInitDialog() 内

 


```
	m_webUICtrl = NULL;
		LPUNKNOWN pUnk1 = m_Web.GetControlUnknown();
		MyDbgPrintf("punk1 %08X",pUnk1);
		if(pUnk1 != NULL)
		{
			IWebBrowser2* pWB2 = NULL;
			HRESULT hr = pUnk1->QueryInterface(IID_IWebBrowser2, (void**)&pWB2);
			ASSERT(SUCCEEDED(hr) && pWB2 != NULL);
			if(SUCCEEDED(hr) && pWB2 != NULL)
			{
				if (!m_webUICtrl)
				{
					m_webUICtrl = new CWebUIController();
				}
				m_webUICtrl->AddRef();
				MyDbgPrintf("gogogo");
				m_webUICtrl->Enable3DBorder(TRUE);     // 此代码禁止三维边框
		//		m_webUICtrl->EnableScrollBar(FALSE); // 此代码禁止滚动条
				m_webUICtrl->SetWebBrowser(pWB2);
				m_webUICtrl->Release();
				pWB2->Release();
			}
		}
```
  
  


 现在就全部搞定了

   
 