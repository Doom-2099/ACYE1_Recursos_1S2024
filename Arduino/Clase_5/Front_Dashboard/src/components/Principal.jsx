import { useEffect, useState } from "react";
import axios from "axios";
import "./Principal.css";

export function Principal({ setContent }) {
  const [tempShow, setTempShow] = useState(true);
  const [ipState, setIpState] = useState("");
  const [portState, setPortState] = useState("");
  const [redState, setRedState] = useState("");
  const [tempValue, setTemp] = useState(0);
  const [humValue, setHum] = useState(0);
  const [habitaciones, setHabitaciones] = useState([
    { id: 1, habitacion: "HABITACION 1", value: false },
    { id: 2, habitacion: "HABITACION 2", value: false },
    { id: 3, habitacion: "SALA", value: false },
    { id: 4, habitacion: "COCINA", value: false },
    { id: 5, habitacion: "GARAGE", value: false },
    { id: 6, habitacion: "JARDIN", value: false },
  ]);

  useEffect(() => {
    M.AutoInit();
    getInfo();
  }, []);

  const getInfo = async () => {
    let data = (await axios.get("http://192.168.0.199:8080/info")).data

    setRedState(data.red);
    setPortState(data.port);
    setIpState(data.ip);
  }

  const changeStateLight = async (index) => {
    /*
     * {
     *   value: true || false
     * }
     */
    let data = (
      await axios.get("http://192.168.0.199:8080/ilumination?id=" + index)
    ).data;

    if (data.value) {
      let newHabitaciones = habitaciones.map((habitacion) => {
        if (habitacion.id === index) {
          M.toast({
            html:
              habitacion.habitacion +
              (!habitacion.value ? " Activada" : " Desactivada"),
            classes: "rounded green darken-2 white-text",
          });

          return {
            id: habitacion.id,
            habitacion: habitacion.habitacion,
            value: !habitacion.value,
          };
        }
        return habitacion;
      });

      setHabitaciones(newHabitaciones);
    } else {
      M.toast({
        html: "Ocurrio Un Error",
        classes: "rounded red darken-2 white-text",
      });
    }
  };

  const getData = async (type) => {
    /*
     * {
     *   state: true || false,
     *   dato: valor
     * }
     */

    let data;

    if (type === "Temperatura") {
      data = (await axios.get("http://192.168.0.199:8080/temperatura")).data;
    } else {
      data = (await axios.get("http://192.168.0.199:8080/humedad")).data
    }
    

    if (data.state) {
      (type === "Temperatura" ? setTemp(data.dato) : setHum(data.dato));
      M.toast({
        html: type + " Actualizada",
        classes: "rounded green darken-2 white-text",
      });
    } else {
      M.toast({
        html: "Error Al Obtener " + type,
        classes: "rounded red darken-2 white-text",
      });
    }
  };

  return (
    <>
      <nav style={{ zIndex: "2" }}>
        <div className="nav-wrapper">
          <a href="#" className="brand-logo">
            Ejemplo IoT
            <span style={{fontSize: "10px"}}>{" | Red: " + redState + " | IP: " + ipState + " | Port: " + portState}</span>
          </a>
          <ul
            className="right hide-on-med-and-down"
            style={{ paddingRight: "50px" }}
          >
            <li>
              <a
                href="#"
                className="tooltipped"
                data-position="bottom"
                data-tooltip="Temperatura"
                onClick={() => setTempShow(true)}
              >
                <i className="material-icons large">thermostat</i>
              </a>
            </li>
            <li>
              <a
                href="#"
                className="tooltipped"
                data-position="bottom"
                data-tooltip="Iluminacion"
                onClick={() => setTempShow(false)}
              >
                <i className="material-icons large">house</i>
              </a>
            </li>
            <li>
            <a
                href="#"
                className="tooltipped"
                data-position="bottom"
                data-tooltip="Logout"
                onClick={() => setContent(false)}
              >
                <i className="material-icons large">logout</i>
              </a>
            </li>
          </ul>
        </div>
      </nav>
      {!tempShow && (
        <section style={{ zIndex: "1" }}>
          <div className="container">
            <div className="row">
              {habitaciones.map((habitacion, index) => {
                return (
                  <div className="col s12 m6" key={index}>
                    <div className="card hoverable info">
                      <div className="card-content white-text center-align">
                        <span className="card-title">
                          {habitacion.habitacion}
                        </span>
                        <a
                          href="#"
                          className={
                            "btn-floating waves-effect waves-light " +
                            (habitacion.value
                              ? "yellow darken-2 black-text"
                              : "grey darken-2 white-text")
                          }
                          onClick={() => changeStateLight(habitacion.id)}
                        >
                          <i className="material-icons">
                            {habitacion.value ? "power" : "power_off"}
                          </i>
                        </a>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </section>
      )}
      {tempShow && (
        <section style={{ zIndex: "1" }}>
          <div className="container">
            <div className="row">
              <div className="col s12 m6">
                <div className="card hoverable info">
                  <div className="card-content white-text center-align">
                    <span className="card-title">TEMPERATURA</span>
                    <p>Temperatura: {tempValue} °C</p>
                  </div>
                  <div className="card-action center-align">
                    <a
                      href="#"
                      className="btn-flat waves-effect waves-light white-text"
                      onClick={() => getData("Temperatura")}
                    >
                      <i className="material-icons left">refresh</i>REFRESCAR
                    </a>
                  </div>
                </div>
              </div>
              <div className="col s12 m6">
                <div className="card hoverable info">
                  <div className="card-content white-text center-align">
                    <span className="card-title">HUMEDAD</span>
                    <p>Humedad: {humValue}%</p>
                  </div>
                  <div className="card-action center-align">
                    <a
                      href="#"
                      className="btn-flat waves-effect waves-light white-text"
                      onClick={() => getData("Humedad")}
                    >
                      <i className="material-icons left">refresh</i>REFRESCAR
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      )}
    </>
  );
}
