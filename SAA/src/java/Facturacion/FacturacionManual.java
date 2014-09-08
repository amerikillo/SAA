/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Facturacion;

import conn.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import servlets.Facturacion;

/**
 *
 * @author Amerikillo
 */
public class FacturacionManual extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ConectionDB con = new ConectionDB();
        ConectionDB_SQLServer consql = new ConectionDB_SQLServer();
        Facturacion fact = new Facturacion();
        java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");
        java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession sesion = request.getSession(true);
        try {
            if (!request.getParameter("accionEliminar").equals("")) {
                con.conectar();
                con.insertar("delete from tb_facttemp where F_IdFact = '" + request.getParameter("accionEliminar") + "' ");
                con.cierraConexion();
                out.println("<script>alert('Clave Eliminada Correctamente')</script>");
                out.println("<script>window.location='facturacionManual.jsp'</script>");
            }

        } catch (Exception e) {
        }
        try {
            System.out.println(request.getParameter("accion"));
            if (request.getParameter("accion").equals("quitarInsumo")) {
                System.out.println(request.getParameter("Nombre") + "*****");
                sesion.setAttribute("Nombre", request.getParameter("Nombre"));
                con.conectar();
                con.insertar("update tb_facttemp set F_StsFact = '1' where F_Id = '" + request.getParameter("IdQuitar") + "' ");
                con.cierraConexion();
                out.println("<script>window.location='remisionarCamion.jsp'</script>");
            }
            if (request.getParameter("accion").equals("CancelarFactura")) {
                try {
                    con.conectar();
                    con.insertar("delete from tb_facttemp where F_ClaCLi = '" + (String) sesion.getAttribute("ClaCliFM") + "' ");
                    con.cierraConexion();
                    out.println("<script>alert('Factura Eliminada Correctamente')</script>");
                    out.println("<script>window.location='facturacionManual.jsp'</script>");
                } catch (Exception e) {
                }
            }
            if (request.getParameter("accion").equals("remisionCamion")) {

                try {
                    String[] claveschk = request.getParameterValues("chkSeleccciona");
                    String claves = "";
                    if (claves != null && claveschk.length > 0) {
                        for (int i = 0; i < claveschk.length; i++) {
                            if (i == claveschk.length - 1) {
                                claves = claves + claveschk[i];
                            } else {
                                claves = claves + claveschk[i] + ",";
                            }
                        }
                    }
                    con.conectar();
                    consql.conectar();
                    int FolioFactura = 0;
                    String ClaUni = request.getParameter("Nombre");
                    String FechaE = request.getParameter("Fecha");
                    ResultSet FolioFact = con.consulta("SELECT F_IndFact FROM tb_indice");
                    while (FolioFact.next()) {
                        FolioFactura = Integer.parseInt(FolioFact.getString("F_IndFact"));
                    }
                    int FolFact = FolioFactura + 1;
                    con.actualizar("update tb_indice set F_IndFact='" + FolFact + "'");
                    String qryFact = "select f.F_ClaCli, l.F_FolLot, l.F_IdLote, l.F_ClaPro, l.F_ClaLot, l.F_FecCad, m.F_TipMed, m.F_Costo, p.F_ClaProve, f.F_Cant, l.F_ExiLot, l.F_Ubica, f.F_IdFact, f.F_Id, f.F_FecEnt  from tb_facttemp f, tb_lote l, tb_medica m, tb_proveedor p where f.F_IdLot = l.F_IdLote AND l.F_ClaPro = m.F_ClaPro AND l.F_ClaOrg = p.F_ClaProve and f.F_ClaCLi = '" + request.getParameter("Nombre") + "' and f.F_StsFact=4 AND (f.F_Id IN (" + claves + ")) ";
                    ResultSet rset = con.consulta(qryFact);
                    while (rset.next()) {
                        String Clave = rset.getString("F_ClaPro");
                        String Caducidad = rset.getString("F_FecCad");
                        String FolioLote = rset.getString("F_FolLot");
                        String IdLote = rset.getString("F_IdLote");
                        String ClaLot = rset.getString("F_ClaLot");
                        String Ubicacion = rset.getString("F_Ubica");
                        String ClaProve = rset.getString("F_ClaProve");
                        String F_Id = rset.getString("F_Id");
                        FechaE = rset.getString("F_FecEnt");
                        int existencia = rset.getInt("F_ExiLot");
                        int cantidad = rset.getInt("F_Cant");
                        int Tipo = rset.getInt("F_TipMed");
                        int FolioMovi = 0, FolMov = 0;
                        double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                        if (Tipo == 2504) {
                            IVA = 0.0;
                        } else {
                            IVA = 0.16;
                        }

                        Costo = rset.getDouble("F_Costo");

                        int Diferencia = existencia - cantidad;

                        //Actualizacion de TB Lote
                        ResultSet rsetLoteSQL = consql.consulta("select F_FolLot as lote from tb_lote where F_ClaPro = '" + Clave + "' and F_ClaLot = '" + ClaLot + "' and F_FecCad = '" + df2.format(df3.parse(Caducidad)) + "'  and F_Origen = '" + fact.dame5car("1") + "' ");
                        String loteSQL = "";
                        while (rsetLoteSQL.next()) {
                            loteSQL = rsetLoteSQL.getString("lote");
                        }
                        if (Diferencia == 0) {
                            con.actualizar("UPDATE tb_lote SET F_ExiLot='0' WHERE F_IdLote='" + IdLote + "'");
                            consql.actualizar("UPDATE TB_lote SET F_ExiLot='0' WHERE F_FolLot='" + loteSQL + "'");
                        } else {
                            con.actualizar("UPDATE tb_lote SET F_ExiLot='" + Diferencia + "' WHERE F_IdLote='" + IdLote + "'");
                            consql.actualizar("UPDATE TB_lote SET F_ExiLot='" + Diferencia + "' WHERE F_FolLot='" + loteSQL + "'");
                        }
                        IVAPro = (cantidad * Costo) * IVA;
                        Monto = cantidad * Costo;
                        MontoIva = Monto + IVAPro;
                        //Obtencion de indice de movimiento

                        ResultSet FolioMov = con.consulta("SELECT F_IndMov FROM tb_indice");
                        while (FolioMov.next()) {
                            FolioMovi = Integer.parseInt(FolioMov.getString("F_IndMov"));
                        }
                        FolMov = FolioMovi + 1;
                        con.actualizar("update tb_indice set F_IndMov='" + FolMov + "'");
                        //Inserciones

                        con.insertar("insert into tb_movinv values(0,curdate(),'" + FolioFactura + "','51','" + Clave + "','" + cantidad + "','" + Costo + "','" + MontoIva + "','-1','" + FolioLote + "','" + Ubicacion + "','" + ClaProve + "',curtime(),'" + sesion.getAttribute("nombre") + "')");
                        con.insertar("insert into tb_factura values(0,'" + FolioFactura + "','" + ClaUni + "','A',curdate(),'" + Clave + "','" + cantidad + "','" + cantidad + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + FolioLote + "','" + FechaE + "',curtime(),'" + sesion.getAttribute("nombre") + "','" + Ubicacion + "')");
                        consql.insertar("insert into TB_MovInv values (CONVERT(date,GETDATE()),'" + FolioFactura + "','','51', '" + Clave + "', '" + cantidad + "', '" + Costo + "','" + IVAPro + "', '" + MontoIva + "' ,'-1', '" + FolioLote + "', '" + FolioMovi + "','A', '0', '','','','" + ClaProve + "','" + sesion.getAttribute("nombre") + "') ");
                        consql.insertar("insert into TB_Factura values ('F','" + FolioFactura + "','" + fact.dame5car(ClaUni) + "','A','',CONVERT(date,GETDATE()),'','" + Clave + "', '','1','" + cantidad + "','" + cantidad + "', '" + Monto + "','0', '" + Monto + "','" + Monto + "','" + Monto + "','" + IVAPro + "', '" + MontoIva + "','" + Costo + "' ,'" + FolioLote + "','R','" + df2.format(df3.parse(FechaE)) + "','" + sesion.getAttribute("nombre") + "','0','0','','A','" + cantidad + "','" + Ubicacion + "') ");

                        ResultSet existSql = consql.consulta("select F_Existen from TB_Medica where F_ClaPro = '" + Clave + "' ");
                        while (existSql.next()) {
                            int difTotal = existSql.getInt("F_Existen") - cantidad;
                            if (difTotal < 0) {
                                difTotal = 0;
                            }
                            consql.actualizar("update TB_Medica set F_Existen = '" + difTotal + "' where F_ClaPro = '" + Clave + "' ");
                        }
                        con.actualizar("update tb_facttemp set F_StsFact='5' where F_Id='" + F_Id + "'");
                    }

                    //Finaliza
                    consql.cierraConexion();
                    con.cierraConexion();
                    sesion.setAttribute("ClaCliFM", "");
                    sesion.setAttribute("FechaEntFM", "");
                    sesion.setAttribute("ClaProFM", "");
                    sesion.setAttribute("DesProFM", "");
                    out.println("<script>window.open('reimpFactura.jsp?fol_gnkl=" + FolioFactura + "','_blank')</script>");
                    out.println("<script>window.location='remisionarCamion.jsp'</script>");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            if (request.getParameter("accion").equals("ConfirmarFactura")) {
                try {
                    con.conectar();
                    consql.conectar();
                    int FolioFactura = 0;
                    String ClaUni = (String) sesion.getAttribute("ClaCliFM");
                    String FechaE = (String) sesion.getAttribute("FechaEntFM");
                    ResultSet FolioFact = con.consulta("SELECT F_IndFact FROM tb_indice");
                    while (FolioFact.next()) {
                        FolioFactura = Integer.parseInt(FolioFact.getString("F_IndFact"));
                    }
                    int FolFact = FolioFactura + 1;
                    con.actualizar("update tb_indice set F_IndFact='" + FolFact + "'");
                    ResultSet rset = con.consulta("select f.F_ClaCli, l.F_FolLot, l.F_IdLote, l.F_ClaPro, l.F_ClaLot, l.F_FecCad, m.F_TipMed, m.F_Costo, p.F_ClaProve, f.F_Cant, l.F_ExiLot, l.F_Ubica, f.F_IdFact  from tb_facttemp f, tb_lote l, tb_medica m, tb_proveedor p where f.F_IdLot = l.F_IdLote AND l.F_ClaPro = m.F_ClaPro AND l.F_ClaOrg = p.F_ClaProve and f.F_ClaCLi = '" + (String) sesion.getAttribute("ClaCliFM") + "' and f.F_StsFact=0 ");
                    while (rset.next()) {
                        String Clave = rset.getString("F_ClaPro");
                        String Caducidad = rset.getString("F_FecCad");
                        String FolioLote = rset.getString("F_FolLot");
                        String IdLote = rset.getString("F_IdLote");
                        String ClaLot = rset.getString("F_ClaLot");
                        String Ubicacion = rset.getString("F_Ubica");
                        String ClaProve = rset.getString("F_ClaProve");
                        int existencia = rset.getInt("F_ExiLot");
                        int cantidad = rset.getInt("F_Cant");
                        int Tipo = rset.getInt("F_TipMed");
                        int FolioMovi = 0, FolMov = 0;
                        double Costo = 0.0, IVA = 0.0, Monto = 0.0, IVAPro = 0.0, MontoIva = 0.0;
                        if (Tipo == 2504) {
                            IVA = 0.0;
                        } else {
                            IVA = 0.16;
                        }

                        Costo = rset.getDouble("F_Costo");

                        int Diferencia = existencia - cantidad;

                        //Actualizacion de TB Lote
                        ResultSet rsetLoteSQL = consql.consulta("select F_FolLot as lote from tb_lote where F_ClaPro = '" + Clave + "' and F_ClaLot = '" + ClaLot + "' and F_FecCad = '" + df2.format(df3.parse(Caducidad)) + "'  and F_Origen = '" + fact.dame5car("1") + "' ");
                        String loteSQL = "";
                        while (rsetLoteSQL.next()) {
                            loteSQL = rsetLoteSQL.getString("lote");
                        }
                        if (Diferencia == 0) {
                            con.actualizar("UPDATE tb_lote SET F_ExiLot='0' WHERE F_IdLote='" + IdLote + "'");
                            consql.actualizar("UPDATE TB_lote SET F_ExiLot='0' WHERE F_FolLot='" + loteSQL + "'");
                        } else {
                            con.actualizar("UPDATE tb_lote SET F_ExiLot='" + Diferencia + "' WHERE F_IdLote='" + IdLote + "'");
                            consql.actualizar("UPDATE TB_lote SET F_ExiLot='" + Diferencia + "' WHERE F_FolLot='" + loteSQL + "'");
                        }
                        IVAPro = (cantidad * Costo) * IVA;
                        Monto = cantidad * Costo;
                        MontoIva = Monto + IVAPro;
                        //Obtencion de indice de movimiento

                        ResultSet FolioMov = con.consulta("SELECT F_IndMov FROM tb_indice");
                        while (FolioMov.next()) {
                            FolioMovi = Integer.parseInt(FolioMov.getString("F_IndMov"));
                        }
                        FolMov = FolioMovi + 1;
                        con.actualizar("update tb_indice set F_IndMov='" + FolMov + "'");
                        //Inserciones

                        con.insertar("insert into tb_movinv values(0,curdate(),'" + FolioFactura + "','51','" + Clave + "','" + cantidad + "','" + Costo + "','" + MontoIva + "','-1','" + FolioLote + "','" + Ubicacion + "','" + ClaProve + "',curtime(),'" + sesion.getAttribute("nombre") + "')");
                        con.insertar("insert into tb_factura values(0,'" + FolioFactura + "','" + ClaUni + "','A',curdate(),'" + Clave + "','" + cantidad + "','" + cantidad + "','" + Costo + "','" + IVAPro + "','" + MontoIva + "','" + FolioLote + "','" + FechaE + "',curtime(),'" + sesion.getAttribute("nombre") + "','" + Ubicacion + "')");
                        consql.insertar("insert into TB_MovInv values (CONVERT(date,GETDATE()),'" + FolioFactura + "','','51', '" + Clave + "', '" + cantidad + "', '" + Costo + "','" + IVAPro + "', '" + MontoIva + "' ,'-1', '" + FolioLote + "', '" + FolioMovi + "','A', '0', '','','','" + ClaProve + "','" + sesion.getAttribute("nombre") + "') ");
                        consql.insertar("insert into TB_Factura values ('F','" + FolioFactura + "','" + fact.dame5car(ClaUni) + "','A','',CONVERT(date,GETDATE()),'','" + Clave + "', '','1','" + cantidad + "','" + cantidad + "', '" + Monto + "','0', '" + Monto + "','" + Monto + "','" + Monto + "','" + IVAPro + "', '" + MontoIva + "','" + Costo + "' ,'" + FolioLote + "','R','" + df2.format(df3.parse(FechaE)) + "','" + sesion.getAttribute("nombre") + "','0','0','','A','" + cantidad + "','" + Ubicacion + "') ");

                        ResultSet existSql = consql.consulta("select F_Existen from TB_Medica where F_ClaPro = '" + Clave + "' ");
                        while (existSql.next()) {
                            int difTotal = existSql.getInt("F_Existen") - cantidad;
                            if (difTotal < 0) {
                                difTotal = 0;
                            }
                            consql.actualizar("update TB_Medica set F_Existen = '" + difTotal + "' where F_ClaPro = '" + Clave + "' ");
                        }
                        con.actualizar("update tb_facttemp set F_StsFact='5' where F_IdFact='" + rset.getString("F_IdFact") + "'");
                    }

                    //Finaliza
                    consql.cierraConexion();
                    con.cierraConexion();
                    sesion.setAttribute("ClaCliFM", "");
                    sesion.setAttribute("FechaEntFM", "");
                    sesion.setAttribute("ClaProFM", "");
                    sesion.setAttribute("DesProFM", "");
                    out.println("<script>window.open('reimpFactura.jsp?fol_gnkl=" + FolioFactura + "','_blank')</script>");
                    out.println("<script>window.location='facturacionManual.jsp'</script>");
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
            if (request.getParameter("accion").equals("AgregarClave")) {
                try {
                    con.conectar();
                    con.insertar("insert into tb_facttemp values(0,'" + (String) sesion.getAttribute("ClaCliFM") + "','" + request.getParameter("IdLot") + "','','" + request.getParameter("Cant") + "','" + (String) sesion.getAttribute("FechaEntFM") + "','0','')");
                    con.cierraConexion();
                    response.sendRedirect("facturacionManual.jsp");
                } catch (Exception e) {
                }
            }
            if (request.getParameter("accion").equals("SeleccionaLote")) {
                System.out.println(request.getParameter("Cantidad"));
                response.setContentType("text/html");
                request.setAttribute("Cantidad", request.getParameter("Cantidad"));
                request.getRequestDispatcher("facturacionManualSelecLote.jsp").forward(request, response);
            }
            if (request.getParameter("accion").equals("btnClave")) {
                try {
                    con.conectar();
                    ResultSet rset = con.consulta("select m.F_ClaPro, m.F_DesPro, l.F_ClaLot, l.F_FolLot, DATE_FORMAT(l.F_FecCad, '%d/%m/%Y') from tb_medica m, tb_lote l where m.F_ClaPro = l.F_ClaPro and m.F_ClaPro = '" + request.getParameter("ClaPro") + "';");
                    while (rset.next()) {
                        sesion.setAttribute("DesProFM", rset.getString(2));
                    }
                    con.cierraConexion();
                    sesion.setAttribute("ClaCliFM", request.getParameter("ClaCli"));
                    sesion.setAttribute("FechaEntFM", request.getParameter("FechaEnt"));
                    sesion.setAttribute("ClaProFM", request.getParameter("ClaPro"));
                    response.sendRedirect("facturacionManual.jsp");
                } catch (Exception e) {
                }
            }
        } catch (Exception e) {
        }
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
