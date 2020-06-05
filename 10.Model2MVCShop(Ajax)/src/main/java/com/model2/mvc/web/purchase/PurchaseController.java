package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.product.impl.ProductServiceImpl;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserService;
import com.model2.mvc.service.user.impl.UserServiceImpl;

@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {

	@Autowired @Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	@Autowired @Qualifier("productServiceImpl")
	private ProductService productService;
	
	public PurchaseController(){
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	
//	@RequestMapping(value="addPurchaseView" , method =RequestMethod.GET)
//	public ModelAndView addPurchaseView() throws Exception {
//		
//		ModelAndView modelAndView = new ModelAndView();
//
//		return new ModelAndView("addPurchaseView.jsp");
//	}
	
	
	@RequestMapping(value="addPurchaseView" , method =RequestMethod.GET)
	public ModelAndView addPurchaseView(@ModelAttribute("purchase") Purchase purchase, @RequestParam("prod_no") int prodNo,  HttpSession session) throws Exception {
		
		System.out.println("prodNo"+prodNo);
		ModelAndView modelAndView = new ModelAndView();
		
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setPurchaseProd(productService.getProduct(prodNo));
		modelAndView.addObject(purchase);
		
		modelAndView.setViewName("/purchase/addPurchaseView.jsp");
		
		return modelAndView;
	}
	
	@RequestMapping(value="addPurchase" , method =RequestMethod.POST)
	public ModelAndView addPurchase(@ModelAttribute("purchase") Purchase purchase, HttpServletRequest request, @RequestParam("prod_no") int prodNo, HttpSession session, Model model) throws Exception {
	
		System.out.println("/addPurchase.do");
		
		ModelAndView modelAndView = new ModelAndView();
		
		purchase.setPurchaseProd(productService.getProduct(prodNo));
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setDivyAddr(request.getParameter("receiverAddr"));
		purchase.setDivyRequest(request.getParameter("receiverRequest"));
		purchase.setDivyDate(request.getParameter("receiverDate"));	
	
		purchaseService.addPurchase(purchase);
		
		modelAndView.addObject(purchase);
		
		modelAndView.setViewName("/purchase/addPurchase.jsp");
		
		return modelAndView;
		
	}
	
	@RequestMapping(value ="getPurchase", method = RequestMethod.GET)
	public ModelAndView getPurchase(@RequestParam("tranNo") int tranNo, HttpServletRequest request) throws Exception {
		
	ModelAndView modelAndView = new ModelAndView();	
	Purchase purchase = purchaseService.getPurchase(tranNo);
	
	modelAndView.addObject(purchase);
	
	modelAndView.setViewName("/purchase/getPurchase.jsp");
	
	return modelAndView;
	}
	
	@RequestMapping(value ="updatePurchaseView", method =RequestMethod.GET)
	public ModelAndView updatePurchaseView( @RequestParam("tranNo") int tranNo) throws Exception{
	
		
		System.out.println("updatePurchaseView.do");
		ModelAndView modelAndView = new ModelAndView();	
		Purchase purchase = purchaseService.getPurchase(tranNo);

		modelAndView.addObject(purchase);
		
		modelAndView.setViewName("/purchase/updatePurchaseView.jsp");
		
		return modelAndView;
	}
	
	@RequestMapping(value ="updatePurchase", method =RequestMethod.POST)
	public ModelAndView updatePurchase( @RequestParam("tranNo") int tranNo, HttpServletRequest request, HttpSession session) throws Exception{
	
		System.out.println("/updatePurchase");
		
		ModelAndView modelAndView = new ModelAndView();
	    Purchase purchase = purchaseService.getPurchase(tranNo);
		purchase.setBuyer((User)session.getAttribute("user"));
		purchase.setTranNo(Integer.parseInt(request.getParameter("tranNo")));
		purchase.setPaymentOption(request.getParameter("paymentOption"));
		purchase.setReceiverName(request.getParameter("receiverName"));
		purchase.setReceiverPhone(request.getParameter("receiverPhone"));
		purchase.setDivyAddr(request.getParameter("receiverAddr"));
		purchase.setDivyRequest(request.getParameter("receiverRequest"));
		purchase.setDivyDate(request.getParameter("divyDate"));

		purchaseService.updatePurchase(purchase);
		
		modelAndView.addObject(purchase);
		
		modelAndView.setViewName("/purchase/getPurchase.jsp");
		
		return modelAndView;
	
	}
	
	

	@RequestMapping(value ="listPurchase")
	public ModelAndView listPurchase( @ModelAttribute("search") Search search , HttpServletRequest request, HttpSession session) throws Exception{
		

		ModelAndView modelAndView = new ModelAndView();
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		System.out.println("search"+search);
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=purchaseService.getPurchaseList(search, ((User)session.getAttribute("user")).getUserId());
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		modelAndView.addObject("list" , map.get("list"));
		modelAndView.addObject("resultPage" ,resultPage);
		modelAndView.addObject("search" , search);
		System.out.println("ModelAndView===================="+modelAndView);
		
		modelAndView.setViewName("/purchase/listPurchase.jsp");
		return modelAndView;
	
	}
	
	@RequestMapping(value ="updateTranCode", method = RequestMethod.GET)
	public ModelAndView updateTranCode(@ModelAttribute("purchase") Purchase purchase, @RequestParam("tranNo") int tranNo, HttpServletRequest request) throws Exception{
		
		
		ModelAndView modelAndView = new ModelAndView();
		
		purchase.setTranNo(Integer.parseInt(request.getParameter("tranNo")));
		purchase.setTranCode(request.getParameter("tranCode"));
		
		purchaseService.updateTranCode(purchase);
		
		modelAndView.addObject("purchase", purchase);
		
		modelAndView.setViewName("listPurchase");
	
		return modelAndView;
		
	}
	@RequestMapping(value = "updateTranCodeByProd", method = RequestMethod.GET)
	public ModelAndView UpdateTranCodeByProd (@ModelAttribute("purchase") Purchase purchase, @ModelAttribute("product") Product product, @RequestParam("prodNo") int prodNo,HttpServletRequest request) throws Exception {
		System.out.println("시작");
		
		ModelAndView modelAndView = new ModelAndView();
		purchase.setTranCode(request.getParameter("tranCode"));
		purchase.setPurchaseProd(product);
		

		purchaseService.updateTranCode(purchase);
		modelAndView.addObject("purchase", purchase);
		
		modelAndView.setViewName("/product/listProduct?menu=manage");
		
		return modelAndView;
	}
}
