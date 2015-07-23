/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import conn.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
public class Altas extends HttpServlet {

    ConectionDB con = new ConectionDB();
    //ConectionDB_SQLServer consql = new ConectionDB_SQLServer();
    java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");
    java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     * 
     * 
     * 
     */
    
    /**
     * Esta Clase se utiliza para la captura de insumos de manera manual, por tanto en este proyecto no se utiliza
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession(true);
        String clave = "", descr = "", cb = "", Cuenta = "", Marca = "", codbar2 = "", PresPro = "";
        int ban1 = 0;
        String boton = request.getParameter("accion");
        String ancla = "";
        try {
            if (request.getParameter("accion").equals("codigo")) {
                /**
                 * 
                 */
                try {
                    con.conectar();
                    ResultSet rset = con.consulta("SELECT F_Cb,COUNT(F_Cb) as cuenta FROM tb_cb WHERE F_Cb='" + request.getParameter("codigo") + "' GROUP BY F_Cb");
                    while (rset.next()) {
                        ban1 = 1;
                        cb = rset.getString("F_Cb");
                        Cuenta = rset.getString("cuenta");
                    }
                    if (Cuenta.equals("")) {
                        Cuenta = "0";
                        cb = request.getParameter("codigo");
                        ban1 = 2;
                    }
                    ancla = "#codigo";
                    con.cierraConexion();
                } catch (Exception e) {

                }
            }
            if (request.getParameter("accion").equals("clave")) {
                /**
                 * Nos devuelve información del insumo a partir de su clave
                 */
                try {
                    con.conectar();
                    cb = request.getParameter("cb");
                    ResultSet rset = con.consulta("select F_ClaPro, F_DesPro,F_PrePro from tb_medica where F_ClaPro='" + request.getParameter("clave") + "'");
                    while (rset.next()) {
                        ban1 = 1;
                        clave = rset.getString("F_ClaPro");
                        descr = rset.getString("F_DesPro");
                        PresPro = rset.getString("F_PrePro");
                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            }
            if (request.getParameter("accion").equals("CodBar")) {
                /**
                 * Para geneara un nuevo código de barrass
                 */
                try {
                    con.conectar();
                    ResultSet rset = con.consulta("SELECT MAX(F_IdCb) AS F_IdCb FROM tb_gencb");
                    while (rset.next()) {
                        ban1 = 1;
                        codbar2 = rset.getString("F_IdCb");
                    }
                    System.out.println(codbar2);
                    Long CB = Long.parseLong(codbar2) + 1;
                    con.insertar("insert into tb_gencb values('" + CB + "','GNKL')");
                    descr = request.getParameter("descripci");
                    clave = request.getParameter("clave1");
                    rset = con.consulta("select F_PrePro from tb_medica where F_ClaPro='" + clave + "'");
                    while (rset.next()) {
                        PresPro = rset.getString("F_PrePro");
                    }
                    Marca = request.getParameter("Marca");
                    con.cierraConexion();
                } catch (Exception e) {

                }
            }
            if (request.getParameter("accion").equals("descripcion")) {
                /**
                 * Nos devuelve información del insumo a partir de su descripcioón
                 */
                try {
                    con.conectar();
                    cb = request.getParameter("cb");
                    ResultSet rset = con.consulta("select F_ClaPro, F_DesPro, F_PrePro from tb_medica where F_DesPro='" + request.getParameter("descr") + "'");
                    while (rset.next()) {
                        ban1 = 1;
                        clave = rset.getString("F_ClaPro");
                        descr = rset.getString("F_DesPro");
                        PresPro = rset.getString("F_PrePro");
                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            }
            if (request.getParameter("accion").equals("refresh")) {
                /**
                 * Para recargar la pagina
                 */
                try {
                    ban1 = 1;
                    descr = request.getParameter("descripci");
                    clave = request.getParameter("clave1");
                    PresPro = request.getParameter("Presentaci");
                } catch (Exception e) {

                }
            }
            if (request.getParameter("accion").equals("capturar")) {
                /**
                 * Para capturar un insumo
                 */
                ban1 = 1;
                String cla_pro = request.getParameter("clave1");
                String Tipo = "", FechaC = "", FechaF = "";
                double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                int fcdu = 0, anofec = 0;
                String lot_pro = request.getParameter("Lote").toUpperCase();
                
                /**
                 * Se maneja la fecha en 3 campos por lo que después de obtenerla se formatea
                 */
                String cdd = request.getParameter("cdd");
                String cmm = request.getParameter("cmm");
                String caa = request.getParameter("caa");
                
                String FeCad = caa + "-" + cmm + "-" + cdd;

                try {
                    /**
                     * Se obtiene el total de cajas, piezas y tarimas
                     */
                    int cajas = Integer.parseInt((request.getParameter("Cajas")).replace(",", ""));
                    int piezas = Integer.parseInt((request.getParameter("Piezas")).replace(",", ""));
                    int tarimas = Integer.parseInt((request.getParameter("Tarimas")).replace(",", ""));

                    con.conectar();

                    /**
                     * Tipo de medicamento para calcular fecha de fabricación y su iva
                     */
                    ResultSet rset_medica = con.consulta("SELECT F_TipMed,F_Costo FROM tb_medica WHERE F_ClaPro='" + cla_pro + "'");
                    while (rset_medica.next()) {
                        Tipo = rset_medica.getString("F_TipMed");
                        Costo = Double.parseDouble(rset_medica.getString("F_Costo"));
                        if (Tipo.equals("2504")) {
                            IVA = 0.0;
                            fcdu = Integer.parseInt(caa);
                            anofec = fcdu - 3;
                        } else {
                            IVA = 0.16;
                            fcdu = Integer.parseInt(caa);
                            anofec = fcdu - 5;
                        }
                    }
                    /**
                     * Para esta clave en especifico se calcula el costo entre 30 ya que fué una modificación posterior al inicio del proyecto solicitada por ISEM
                     */
                    if (cla_pro.equals("4186")) {
                        Costo = Costo / 30;
                    }
                    
                    /**
                     * Calculo de Fecha de fabricación e importe
                     */
                    String FeFab = anofec + "-" + cmm + "-" + cdd;
                    IVAPro = (piezas * Costo) * IVA;
                    Monto = piezas * Costo;
                    MontoIva = Monto + IVAPro;
                    /**
                     * Restos e incompletas
                     */
                    String tarimaI = request.getParameter("TarimasI");
                    if (tarimaI.equals("")) {
                        tarimaI = "0";
                    }
                    String resto = request.getParameter("Resto");
                    if (resto.equals("")) {
                        resto = "0";
                    }
                    String cajasI = request.getParameter("CajasxTI");
                    if (cajasI.equals("")) {
                        cajasI = "0";
                    }
                    
                    /**
                     * Obtención de las observaciones
                     * Se cacha en un tipo byte para que los acentos y las ñ no afecten en nada
                     */
                    byte[] a = request.getParameter("Observaciones").getBytes("ISO-8859-1");
                    String Obser = (new String(a, "UTF-8")).toUpperCase();
                    
                    /**
                     * Inserción en compra temporal
                     */
                    con.insertar("insert into tb_compratemp values (0,curdate(),'" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "','" + request.getParameter("Marca") + "','" + request.getParameter("provee") + "','" + request.getParameter("cb") + "', '" + tarimas + "', '" + cajas + "', '" + piezas + "', '" + tarimaI + "','" + cajasI + "', '" + resto + "', '" + Costo + "', '" + IVAPro + "', '" + MontoIva + "','" + Obser + "' , '" + request.getParameter("folio_remi") + "', '" + request.getParameter("orden") + "','" + request.getParameter("provee") + "' ,'" + sesion.getAttribute("nombre") + "','1') ");
                    con.insertar("insert into tb_compraregistro values (0,curdate(),'" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "','" + request.getParameter("Marca") + "','" + request.getParameter("provee") + "','" + request.getParameter("cb") + "', '" + tarimas + "', '" + cajas + "', '" + piezas + "', '" + tarimaI + "','" + cajasI + "', '" + resto + "', '" + Costo + "', '" + IVAPro + "', '" + MontoIva + "','" + Obser + "' , '" + request.getParameter("folio_remi") + "', '" + request.getParameter("orden") + "','" + request.getParameter("provee") + "' ,'" + sesion.getAttribute("nombre") + "') ");

                    con.insertar("insert into tb_pzcaja values (0,'" + request.getParameter("provee") + "','" + Marca + "','" + request.getParameter("PzsxCC") + "','" + cla_pro.toUpperCase() + "')");
                    con.insertar("insert into tb_cb values(0,'" + request.getParameter("cb") + "','" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "', '" + request.getParameter("Marca") + "')");
                    con.cierraConexion();

                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            if (request.getParameter("accion").equals("capturarcb")) {
                
                /**
                 * Capturar con base del CB
                 * no se utiliza
                 */
                ban1 = 1;
                String cla_pro = request.getParameter("clave1");
                String Tipo = "", FechaC = "", FechaF = "";
                double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                String lot_pro = request.getParameter("Lote");
                String FeCad = request.getParameter("cdd");
                String FeFab = request.getParameter("fdd");

                try {
                    int cajas = Integer.parseInt((request.getParameter("Cajas")).replace(",", ""));
                    int piezas = Integer.parseInt((request.getParameter("Piezas")).replace(",", ""));
                    int tarimas = Integer.parseInt((request.getParameter("Tarimas")).replace(",", ""));

                    con.conectar();

                    ResultSet rset_medica = con.consulta("SELECT F_TipMed,F_Costo FROM tb_medica WHERE F_ClaPro='" + cla_pro + "'");
                    while (rset_medica.next()) {
                        Tipo = rset_medica.getString("F_TipMed");
                        Costo = Double.parseDouble(rset_medica.getString("F_Costo"));
                        if (Tipo.equals("2504")) {
                            IVA = 0.0;
                        } else {
                            IVA = 0.16;
                        }
                    }

                    String tarimaI = request.getParameter("TarimasI");
                    if (tarimaI.equals("")) {
                        tarimaI = "0";
                    }
                    String cajasI = request.getParameter("CajasxTI");
                    if (cajasI.equals("")) {
                        cajasI = "0";
                    }
                    String resto = request.getParameter("Resto");
                    if (resto.equals("")) {
                        resto = "0";
                    }
                    if (cla_pro.equals("4186")) {
                        Costo = Costo / 30;
                    }
                    IVAPro = (piezas * Costo) * IVA;
                    Monto = piezas * Costo;
                    MontoIva = Monto + IVAPro;

                    ResultSet Fechac = con.consulta("SELECT STR_TO_DATE('" + FeCad + "', '%d/%m/%Y')");
                    while (Fechac.next()) {
                        FeCad = Fechac.getString("STR_TO_DATE('" + FeCad + "', '%d/%m/%Y')");
                    }
                    ResultSet Fechaf = con.consulta("SELECT STR_TO_DATE('" + FeFab + "', '%d/%m/%Y')");
                    while (Fechaf.next()) {
                        FeFab = Fechaf.getString("STR_TO_DATE('" + FeFab + "', '%d/%m/%Y')");
                    }
                    byte[] a = request.getParameter("Observaciones").getBytes("ISO-8859-1");
                    String Obser = (new String(a, "UTF-8")).toUpperCase();
                    con.insertar("insert into tb_compratemp values (0,curdate(),'" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "','" + request.getParameter("Marca") + "','" + request.getParameter("provee") + "','" + request.getParameter("cb") + "', '" + tarimas + "', '" + cajas + "', '" + piezas + "', '" + tarimaI + "','" + cajasI + "', '" + resto + "', '" + Costo + "', '" + IVAPro + "', '" + MontoIva + "' ,'" + Obser + "', '" + request.getParameter("folio_remi") + "', '" + request.getParameter("orden") + "','" + request.getParameter("provee") + "' ,'" + sesion.getAttribute("nombre") + "','1') ");
                    con.insertar("insert into tb_compraregistro values (0,curdate(),'" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "','" + request.getParameter("Marca") + "','" + request.getParameter("provee") + "','" + request.getParameter("cb") + "', '" + tarimas + "', '" + cajas + "', '" + piezas + "', '" + tarimaI + "','" + cajasI + "', '" + resto + "', '" + Costo + "', '" + IVAPro + "', '" + MontoIva + "' ,'" + Obser + "', '" + request.getParameter("folio_remi") + "', '" + request.getParameter("orden") + "','" + request.getParameter("provee") + "' ,'" + sesion.getAttribute("nombre") + "') ");
                    try {

                        con.insertar("insert into tb_pzcaja values (0,'" + request.getParameter("provee") + "','" + Marca + "','" + request.getParameter("PzsxCC") + "','" + cla_pro.toUpperCase() + "')");
                    } catch (Exception e) {
                    }
                    con.insertar("insert into tb_cb values(0,'" + request.getParameter("cb") + "','" + cla_pro.toUpperCase() + "','" + lot_pro + "','" + FeCad + "','" + FeFab + "', '" + request.getParameter("Marca") + "')");
                    con.cierraConexion();

                } catch (Exception e) {

                    System.out.println(e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        request.getSession().setAttribute("folio", request.getParameter("folio"));
        request.getSession().setAttribute("fecha", request.getParameter("fecha"));
        request.getSession().setAttribute("folio_remi", request.getParameter("folio_remi"));
        request.getSession().setAttribute("orden", request.getParameter("orden"));
        request.getSession().setAttribute("provee", request.getParameter("provee"));
        request.getSession().setAttribute("recib", request.getParameter("recib"));
        request.getSession().setAttribute("entrega", request.getParameter("entrega"));
        request.getSession().setAttribute("clave", clave);
        request.getSession().setAttribute("descrip", descr);
        request.getSession().setAttribute("cuenta", Cuenta);
        request.getSession().setAttribute("cb", cb);
        request.getSession().setAttribute("codbar2", codbar2);
        request.getSession().setAttribute("Marca", Marca);
        request.getSession().setAttribute("PresPro", PresPro);

        //String original = "hello world";
        //byte[] utf8Bytes = original.getBytes("UTF8");
        //String value = new String(utf8Bytes, "UTF-8"); 
        //out.println(value);
        if (ban1 == 0) {
            out.println("<script>alert('Clave Inexistente')</script>");
            out.println("<script>window.location='captura.jsp'</script>");
        } else if (ban1 == 1) {
            out.println("<script>window.location='captura.jsp'</script>");
        } else if (ban1 == 2) {
            request.getSession().setAttribute("CBInex", "1");
            out.println("<script>alert('CB Inexistente, Favor de Llenar todos los Campos')</script>");
            out.println("<script>window.location='captura.jsp'</script>");
        }
        //response.sendRedirect("captura.jsp");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
