/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import conn.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
public class ServletK extends HttpServlet {

    
    conection ObjMySQL = new conection();
    ConectionDB_SQLServer ObjSql = new ConectionDB_SQLServer();
    String Query;
    ResultSet Consultas = null;

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
        response.setContentType("text/html;charset=UTF-8");
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
        try {
            processRequest(request, response);
            PrintWriter out = response.getWriter();
            HttpSession sesion = request.getSession(true);
            String Folio = "", Ubicacion = "", QueryDatos = "", QueryDatosSQL = "", Id = "", Fabricacion = "", CB = "", PiezasL = "",an1="", mes="", dia="";
            int ban, posi = 0, CajasM = 0, RestoM = 0, Piezas = 0, Existencia = 0, Cantidad = 0, CantidadM = 0, Resultado = 0, Diferencia = 0, ban2 = 0, CajasN = 0, x = 0;
            int posiid = 0, Org = 0, Marca = 0, TipoM = 0, FolioL = 0, FolioLote = 0, Cont = 0, ann1 = 0, difeann1=0, FolMov=0, FolMovi=0;
            double Costo = 0.0, Monto = 0.0, Iva = 0.0, IvaT = 0.0, MontoT = 0.0;
            double ExistenciaSql=0.0, RestoMSql=0.0, ResultadoSql=0.0;
            ResultSet Consulta = null;
            ResultSet ConsultaSQL = null;

            ban = Integer.parseInt(request.getParameter("ban"));
            String Usuario = request.getParameter("usuario");
            String Usuario2 = request.getParameter("usua");
            String Pass = request.getParameter("password");
            String Cadena = request.getParameter("folio");
            String Folio1 = request.getParameter("folio1");
            String Folio2 = request.getParameter("folio2");
            String Fecha = request.getParameter("fecha");
            String Cajas = request.getParameter("cajasm");
            String Resto = request.getParameter("restom");
            String Ubinew = request.getParameter("ubin");
            String Clave = request.getParameter("clave");
            String Lote = request.getParameter("lote");
            String Caducidad = request.getParameter("caducidad");
            String Caducidad2 = request.getParameter("caducidad");
            String Pzcj = request.getParameter("piezas");
            String Unidad = request.getParameter("nombre");
            String Provee = request.getParameter("proveedor");
            String CBM = request.getParameter("cb");
            String MarcaM = request.getParameter("marca");
            HttpSession Session = request.getSession(true);
            
            ObjMySQL.conectar();
            ObjSql.conectar();
            
             out.println(ban);
             
            switch (ban) {
                case 1:
                    Query = "SELECT F_Usu,F_Nombre,F_TipUsu FROM tb_usuario WHERE F_Usu='" + Usuario + "' AND F_Pass=PASSWORD('" + Pass + "') AND F_Status='A'";
                    System.out.println(Query);
                    Consultas = ObjMySQL.consulta(Query);
                    if (Consultas.next()) {

                        String Usuarios = Consultas.getString("F_Usu");
                        String Nombre = Consultas.getString("F_Nombre");
                        String Tipo = Consultas.getString("F_TipUsu");
                        Session.setAttribute("Valida", "Valido");
                        Session.setAttribute("Usuario", Usuarios);
                        Session.setAttribute("Nombre", Nombre);
                        Session.setAttribute("Tipo", Tipo);
                        if ((Tipo.equals("3")) || (Tipo.equals("4"))) {
                            response.sendRedirect("Ubicaciones/Consultas.jsp");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                    } else {
                        response.sendRedirect("index.jsp");
                    }
                    break;
                case 2:
                    posi = Cadena.indexOf(':');
                    posiid = Cadena.lastIndexOf(';');
                    Folio = Cadena.substring(0, posi);
                    Ubicacion = Cadena.substring(posi + 1, posiid);
                    Id = Cadena.substring(posiid + 1);
                    Session.setAttribute("folio", Folio);
                    Session.setAttribute("ubicacion", Ubicacion);
                    Session.setAttribute("id", Id);
                    response.sendRedirect("Ubicaciones/Redistribucion.jsp");
                    break;

                case 3:

                    Folio = (String) Session.getAttribute("folio");
                    Ubicacion = (String) Session.getAttribute("ubicacion");
                    Id = (String) Session.getAttribute("id");
                    Usuario = (String) Session.getAttribute("Usuario");
                    //out.println(Folio+"/"+Ubicacion+"/"+Usuario);
                    QueryDatos = "SELECT L.F_ClaPro AS F_ClaPro,L.F_ClaLot AS F_ClaLot,L.F_FecCad AS F_FecCad,L.F_ClaOrg AS F_ClaOrg,L.F_FecFab AS F_FecFab,L.F_Cb AS F_Cb,L.F_ClaMar AS F_ClaMar,M.F_Costo AS F_Costo,M.F_TipMed AS F_TipMed,L.F_ExiLot as cant FROM tb_lote L INNER JOIN tb_medica M ON L.F_ClaPro=M.F_ClaPro where L.F_ExiLot>0 AND L.F_IdLote='" + Id + "' AND L.F_FolLot='" + Folio + "' AND L.F_Ubica='" + Ubicacion + "'";
                    Consulta = ObjMySQL.consulta(QueryDatos);
                    if (Consulta.next()) {
                        Clave = Consulta.getString("F_ClaPro");
                        Lote = Consulta.getString("F_ClaLot");
                        Caducidad = Consulta.getString("F_FecCad");
                        Org = Integer.parseInt(Consulta.getString("F_ClaOrg"));
                        Fabricacion = Consulta.getString("F_FecFab");
                        CB = Consulta.getString("F_Cb");
                        Marca = Integer.parseInt(Consulta.getString("F_ClaMar"));
                        Costo = Double.parseDouble(Consulta.getString("F_Costo"));
                        TipoM = Integer.parseInt(Consulta.getString("F_TipMed"));
                        Existencia = Integer.parseInt(Consulta.getString("cant"));

                    }
                    if (TipoM == 2504) {
                        Iva = 0.0;
                    } else {
                        Iva = 0.16;
                    }
                    if (Resto != "") {
                        RestoM = Integer.parseInt(Resto);
                        CantidadM = RestoM;
                    }

                    QueryDatos = "select F_ExiLot as EXI from tb_lote where F_FolLot='" + Folio + "' AND F_Ubica='" + Ubinew + "'";
                    Consulta = ObjMySQL.consulta(QueryDatos);
                    if (Consulta.next()) {
                        Cantidad = Integer.parseInt(Consulta.getString("EXI"));
                        PiezasL = Consulta.getString("EXI");
                    }

                    Diferencia = Existencia - CantidadM;
                    IvaT = (CantidadM * Costo) * Iva;
                    Monto = CantidadM * Costo;
                    MontoT = Monto + IvaT;

                    if (!(PiezasL.equals(""))) {

                        Resultado = CantidadM + Cantidad;
                        ObjMySQL.actualizar("update tb_lote set F_ExiLot='" + Resultado + "' WHERE F_FolLot='" + Folio + "' AND F_Ubica='" + Ubinew + "'");
                    } else {
                        System.out.println(Diferencia + "/" + Folio + "/" + Ubinew + "/" + CantidadM);
                        ObjMySQL.actualizar("insert into tb_lote values(0,'" + Clave + "','" + Lote + "','" + Caducidad + "','" + CantidadM + "','" + Folio + "','" + Org + "','" + Ubinew + "','" + Fabricacion + "','" + CB + "','" + Marca + "')");

                    }

                    ObjMySQL.actualizar("insert into tb_movinv values(0,curdate(),'0','1000','" + Clave + "','" + CantidadM + "','" + Costo + "','" + MontoT + "','-1','" + Folio + "','" + Ubicacion + "','" + Org + "',curtime(),'" + Usuario + "')");
                    ObjMySQL.actualizar("insert into tb_movinv values(0,curdate(),'0','1000','" + Clave + "','" + CantidadM + "','" + Costo + "','" + MontoT + "','1','" + Folio + "','" + Ubinew + "','" + Org + "',curtime(),'" + Usuario + "')");

                    if (Diferencia == 0) {

                        ObjMySQL.actualizar("update tb_lote set F_ExiLot='0' where F_IdLote='" + Id + "' AND F_FolLot='" + Folio + "' AND F_Ubica='" + Ubicacion + "'");
                        response.sendRedirect("Ubicaciones/Consultas.jsp");
                    } else {
                        ObjMySQL.actualizar("update tb_lote set F_ExiLot='" + Diferencia + "' where F_IdLote='" + Id + "' AND F_FolLot='" + Folio + "' AND F_Ubica='" + Ubicacion + "'");
                        Session.setAttribute("folio", Folio);
                        Session.setAttribute("ubicacion", Ubicacion);
                        Session.setAttribute("id", Id);
                        response.sendRedirect("Ubicaciones/Redistribucion.jsp");
                    }

                    break;
                case 4:
                    Session.setAttribute("clave", Clave);
                    Session.setAttribute("lote", Lote);
                    Session.setAttribute("caducidad", Caducidad);
                    Session.setAttribute("ubicacion", Ubinew);
                    Session.setAttribute("piezas", Pzcj);
                    Session.setAttribute("cajas", Cajas);
                    Session.setAttribute("resto", Resto);
                    Session.setAttribute("ban", "1");
                    response.sendRedirect("jsp/IngresoM.jsp");
                    break;
                case 5:

                    posi = Cadena.indexOf('/');
                    Folio = Cadena.substring(0, posi);
                    ban2 = Integer.parseInt(Cadena.substring(posi + 1));

                    if (ban2 == 1) {

                    } else if (ban2 == 2) {
                        Session.setAttribute("folio", Folio);
                        response.sendRedirect("Eliminar.jsp");
                    }

                    break;
                case 6:
                    Session.setAttribute("folio", Cadena);
                    Session.setAttribute("ban", "2");
                    response.sendRedirect("jsp/IngresoM.jsp");
                    break;
                case 7:
                    Query = "SELECT * from tb_marbetes where F_Fecha=CURDATE() and F_NomUni='" + Unidad + "' and F_Folio='" + Cadena + "' and F_Paq='" + Cajas + "'";
                    Consultas = ObjMySQL.consulta(Query);
                    if (Consultas.next()) {
                        posi++;
                    }
                    if (posi == 0) {
                        CajasN = Integer.parseInt(Cajas);
                        for (x = 1; x <= CajasN; x++) {
                            out.println(x);
                            ObjMySQL.actualizar("Insert into tb_marbetes values('" + Unidad + "','" + Cadena + "','" + Cajas + "','" + x + "',curdate(),0)");
                        }
                        Session.setAttribute("nombre", Unidad);
                        Session.setAttribute("cajas", Cajas);
                        Session.setAttribute("folio", Cadena);
                        response.sendRedirect("Marbete.jsp");
                    } else {
                        Session.setAttribute("nombre", Unidad);
                        Session.setAttribute("cajas", Cajas);
                        Session.setAttribute("folio", Cadena);
                        response.sendRedirect("Marbete.jsp");
                    }
                    break;
                case 8:
                    if (Folio1 != "" && Folio2 != "" && Fecha != "") {
                        Session.setAttribute("folio1", Folio1);
                        Session.setAttribute("folio2", Folio2);
                        Session.setAttribute("fecha", Fecha);
                        Session.setAttribute("ban", "1");
                        response.sendRedirect("MarbeteT.jsp");

                    } else {
                        Session.setAttribute("folio1", Folio1);
                        Session.setAttribute("folio2", Folio2);
                        Session.setAttribute("ban", "2");
                        response.sendRedirect("MarbeteT.jsp");
                    }
                    break;
                  case 9:
                    RestoM = Integer.parseInt(Resto);
                    RestoMSql = Double.parseDouble(Resto);
                    QueryDatos = "SELECT F_TipMed,F_Costo FROM tb_medica where F_ClaPro='"+Clave+"'";
                    Consulta = ObjMySQL.consulta(QueryDatos);
                    if (Consulta.next()) {
                        Costo = Double.parseDouble(Consulta.getString("F_Costo"));
                        TipoM = Integer.parseInt(Consulta.getString("F_TipMed"));                        
                    }
                    QueryDatos = "SELECT STR_TO_DATE('"+Caducidad+"', '%d/%m/%Y')";
                    Consulta = ObjMySQL.consulta(QueryDatos);
                    if (Consulta.next()) { 
                        Caducidad= Consulta.getString("STR_TO_DATE('"+Caducidad+"', '%d/%m/%Y')");
                    }
                    if (TipoM == 2504) {
                        Iva = 0.0;
                        an1 = Caducidad.substring(0,4);
                        mes = Caducidad.substring(5,7);
                        dia = Caducidad.substring(8,10);
                        ann1 = Integer.parseInt(an1);
                        difeann1 = ann1 - 3;
                        Fabricacion = difeann1 +"-"+ mes +"-"+ dia;
                        
                    } else {
                        Iva = 0.16;
                        an1 = Caducidad.substring(0,4);
                        mes = Caducidad.substring(5,7);
                        dia = Caducidad.substring(8,10);
                        ann1 = Integer.parseInt(an1);
                        difeann1 = ann1 - 5;
                        Fabricacion = difeann1 + mes + dia;
                    }
                    IvaT = (RestoM * Costo) * Iva;
                    Monto = RestoM * Costo;
                    MontoT = Monto + IvaT;
                    
                    //////************************** consulta mysql********//////////////
                    QueryDatos = "SELECT F_FolLot, F_ExiLot FROM tb_lote WHERE F_ClaPro='"+Clave+"' AND F_ClaLot='"+Lote+"' AND F_FecCad='"+Caducidad+"' AND F_Ubica='"+Ubinew+"' AND F_ClaOrg='"+Provee+"' AND F_Cb='"+CBM+"' AND F_ClaMar='"+MarcaM+"'";
                    Consulta = ObjMySQL.consulta(QueryDatos);
                    if (Consulta.next()) {  
                        Cont ++;
                        FolioL = Integer.parseInt(Consulta.getString("F_FolLot"));                        
                        Existencia = Integer.parseInt(Consulta.getString("F_ExiLot"));                        
                    }
                    if (Cont > 0 ){
                        Resultado = Existencia + RestoM;
                        ObjMySQL.actualizar("UPDATE tb_lote SET F_ExiLot='"+Resultado+"' where F_FolLot='"+FolioL+"' AND F_Ubica='"+Ubinew+"'");
                        ObjMySQL.actualizar("INSERT INTO tb_movinv values(0,curdate(),'0','2','"+Clave+"','"+RestoM+"','"+Costo+"','"+MontoT+"','1','"+FolioL+"','"+Ubinew+"','"+Provee+"',CURTIME(),'" + sesion.getAttribute("nombre") + "')");
                        
                        out.println(Resultado);
                    }else{                        
                        QueryDatos = "SELECT F_IndLote FROM tb_indice";
                        Consulta = ObjMySQL.consulta(QueryDatos);
                        if (Consulta.next()) {                              
                            FolioL = Integer.parseInt(Consulta.getString("F_IndLote"));                                                    
                        }
                        FolioLote = FolioL + 1;
                        ObjMySQL.actualizar("update tb_indice set F_IndLote='"+FolioLote+"'");
                        ObjMySQL.actualizar("INSERT INTO tb_lote VALUES (0,'"+Clave+"','"+Lote+"','"+Caducidad+"','"+RestoM+"','"+FolioL+"','"+Provee+"','"+Ubinew+"','"+Fabricacion+"','"+CBM+"','"+MarcaM+"')");
                        ObjMySQL.actualizar("INSERT INTO tb_movinv values(0,curdate(),'0','2','"+Clave+"','"+RestoM+"','"+Costo+"','"+MontoT+"','1','"+FolioL+"','"+Ubinew+"','"+Provee+"',CURTIME(),'" + sesion.getAttribute("nombre") + "')");                       
                        
                    }
                    //////**************************fin consulta mysql********//////////////
                    
                    //////************************** consulta sql********//////////////
                    
                    QueryDatosSQL = "SELECT F_FolLot, F_ExiLot FROM tb_lote WHERE F_ClaPro='"+Clave+"' AND F_ClaLot='"+Lote+"' AND F_FecCad='"+Caducidad2+"' AND F_ClaPrv='"+Provee+"' AND F_ClaMar='"+MarcaM+"'";
                    ConsultaSQL = ObjSql.consulta(QueryDatosSQL);
                    if (ConsultaSQL.next()) {  
                        Cont ++;
                        FolioL = Integer.parseInt(ConsultaSQL.getString("F_FolLot"));                        
                        ExistenciaSql = Double.parseDouble(ConsultaSQL.getString("F_ExiLot"));                        
                    }
                    QueryDatosSQL = "select F_IM from TB_Indice";
                    ConsultaSQL = ObjSql.consulta(QueryDatosSQL);
                    if (ConsultaSQL.next()) {                              
                        FolMov = Integer.parseInt(ConsultaSQL.getString("F_IM"));                                                    
                    }
                    FolMovi = FolMov + 1;
                    ObjSql.actualizar("UPDATE TB_Indice SET F_IM='"+FolMovi+"'");
                        
                    if (Cont > 0 ){                        
                        ResultadoSql = ExistenciaSql + RestoMSql;
                        ObjSql.actualizar("UPDATE tb_lote SET F_ExiLot='"+ResultadoSql+"' where F_FolLot='"+FolioL+"'");
                        ObjSql.actualizar("INSERT INTO tb_movinv values(CONVERT (date, GETDATE()),'0','','11','"+Clave+"','"+RestoMSql+"','"+Costo+"','"+IvaT+"','"+MontoT+"','1','"+FolioL+"','"+FolMov+"','A','0','','','','"+Provee+"','" + sesion.getAttribute("nombre") + "')");
                        
                        out.println(Resultado);
                    }else{                        
                        QueryDatosSQL = "SELECT F_IL FROM tb_indice";
                        ConsultaSQL = ObjSql.consulta(QueryDatosSQL);
                        if (ConsultaSQL.next()) {                              
                            FolioL = Integer.parseInt(ConsultaSQL.getString("F_IL"));                                                    
                        }
                        FolioLote = FolioL + 1;
                        ObjSql.actualizar("update tb_indice set F_IL='"+FolioLote+"'");
                        ObjSql.actualizar("INSERT INTO tb_lote VALUES ('"+Lote+"','"+Clave+"','"+Caducidad2+"','"+RestoMSql+"','"+Costo+"','"+FolioL+"','1','','1','"+Fabricacion+"','0','"+Provee+"','','"+MarcaM+"')");
                        ObjSql.actualizar("INSERT INTO tb_movinv values(CONVERT (date, GETDATE()),'0','','11','"+Clave+"','"+RestoMSql+"','"+Costo+"','"+IvaT+"','"+MontoT+"','1','"+FolioL+"','"+FolMov+"','A','0','','','','"+Provee+"','" + sesion.getAttribute("nombre") + "')");
                        
                    }
                    
                    //////**************************fin consulta mysql********//////////////
                    response.sendRedirect("Ubicaciones/Agregar.jsp");
                    break;
                case 10:
                    posi = Cadena.indexOf(':');
                    posiid = Cadena.lastIndexOf(';');
                    Folio = Cadena.substring(0, posi);
                    Ubicacion = Cadena.substring(posi + 1, posiid);
                    Id = Cadena.substring(posiid + 1);
                    Session.setAttribute("folio", Folio);
                    Session.setAttribute("ubicacion", Ubicacion);
                    Session.setAttribute("id", Id);
                    response.sendRedirect("Ubicaciones/Redistribucion.jsp");
                    break;   

            }
            
            
            ObjMySQL.CierreConn();
            ObjSql.cierraConexion();
            out.close();
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
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
