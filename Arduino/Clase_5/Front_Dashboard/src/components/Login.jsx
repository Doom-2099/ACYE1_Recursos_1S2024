import { useState } from "react";
import "./Login.css";
import axios from "axios";

export function Login({ setContent }) {
  const [user, setUser] = useState("");
  const [pass, setPass] = useState("");

  const login = async () => {
    /* 
    {
      state: true
    } */
    let data = await (
      await axios.get(
        "http://192.168.0.199:8080/login?user=" + user + "&pass=" + pass
      )
    ).data;
    if (data.state) {
      setContent(true);
      
      M.toast({
        html: "Bienvenido",
        classes: "rounded light-green darken-3 white-text",
      });
    } else {
      M.toast({
        html: "Credenciales Incorrectas",
        classes: "rounded light-green darken-3 white-text",
      });
    }
  };

  return (
    <section>
      <div className="container">
        <div className="row">
          <div className="col s8 offset-s2">
            <div className="card-panel hoverable form-box animate-box">
              <div className="card-content">
                <blockquote>
                  <h3 className="white-text text-darken-2 center-align">
                    ACYE1 A - Clase 6
                  </h3>
                </blockquote>
                <h4 className="white-text text-darken-2 center-align">Login</h4>
                <div className="row">
                  <form className="col s12">
                    <div className="row">
                      <div className="input-field col s12">
                        <i className="material-icons prefix white-text">
                          badge
                        </i>
                        <input
                          type="text"
                          id="userSpace"
                          className="validate white-text"
                          onChange={(element) => setUser(element.target.value)}
                        />
                        <label htmlFor="userSpace" className="white-text">
                          Username
                        </label>
                      </div>
                    </div>
                    <div className="row">
                      <div className="input-field col s12">
                        <i className="material-icons prefix white-text">
                          password
                        </i>
                        <input
                          type="password"
                          className="validate white-text"
                          id="passSpace"
                          onChange={(element) => setPass(element.target.value)}
                        />
                        <label htmlFor="passSpace" className="white-text">
                          Password
                        </label>
                      </div>
                    </div>
                    <div className="row center-align">
                      <a
                        className="waves-effect waves-light btn-large"
                        onClick={() => login()}
                      >
                        <i className="material-icons left">login</i>
                        Login
                      </a>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
