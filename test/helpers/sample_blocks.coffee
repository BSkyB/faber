window.sampleBlocks = [
  {
    "inputs": {
      "contents": "<h1>Connect to your wireless network</h1>"
    },
    "component": {
      "name": "Text",
      "inputs": [
        {
          "contents": "html"
        }
      ],
      "template": "text",
      "type": "element"
    }
  },
  {
    "inputs": {
      "contents": "<p>To set up a wireless connection with Sky Broadband you will need the Sky Hub or Sky router and a wireless-enabled computer.</p> \n<p>First you’ll need to unpack and start up your router. This may be the new Sky Hub or an older version of the Sky router. You can find help and advice on doing this in our <a href=\"/broadband/set-up/set-up-your-sky-hub\" onclick=\"s_objectID=&quot;http://stage-help.herokuapp.com/broadband/set-up/set-up-your-sky-hub_1&quot;;return this.s_oc?this.s_oc(e):true\">Setting up your Sky Hub guide</a>.</p> \n<p>Once you have set up your router, <a href=\" http://www.sky.com/helpcentre/video/skybroadbandhelpvideos/settingupawirelessconnection.html\" onclick=\"s_objectID=&quot;http://www.sky.com/helpcentre/video/skybroadbandhelpvideos/settingupawirelessconnection.html_1&quot;;return this.s_oc?this.s_oc(e):true\">watch our video</a> or follow the steps below. </p> \n<p>Please note that the router in the video may be different from your router at home, but the principle of connecting to the internet is exactly the same.</p> \n<p>Don't forget to check your Sky Broadband activation date. You will not be able to set up your broadband connection if your Sky Broadband has not been activated yet. You can find this on the top of your Sky router box, on the Welcome Letter from Sky or you can <a href=\"https://myaccount.sky.com/orders\" onclick=\"s_objectID=&quot;https://myaccount.sky.com/orders_1&quot;;return this.s_oc?this.s_oc(e):true\">check online to see if your service has been activated</a>.</p>"
    },
    "component": {
      "name": "Text",
      "inputs": [
        {
          "contents": "html"
        }
      ],
      "template": "text",
      "type": "element"
    }
  },
  {
    "component": {
      "name": "Tabs",
      "inputs": [
        {
          "title": "text"
        }
      ],
      "template": "tabs",
      "type": "group"
    },
    "blocks": [
      {
        "inputs": {
          "title": "Windows 7"
        },
        "blocks": [
          {
            "inputs": {
              "contents": "<h3>1. Find wireless networks</h3> \n<p>Click on the icon in the system tray (near your taskbar clock) to see available wireless networks.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows7-find-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>2. Select your wireless network</h3> \n<p>Your Sky Hub’s wireless details should appear in the list of networks. You'll find the name of your wireless network on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Click on your Sky Hub’s network name and click <strong>Connect</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows7-select-your-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>3. Enter your wireless password</h3> \n<p>The Security Key is your password. This can be found on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Enter your password in capital letters and click <strong>OK</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows7-enter-wireless-password.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<p>If you are asked for a PIN then insert this instead of the password and click <strong>OK</strong>.</p> \n<p><strong>OR</strong></p> \n<p>Push the <strong>WPS button</strong> (Wi-Fi Protected Setup) and hold it in for two seconds. The wireless icon will flash amber.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/black-sky-hub-amber-wps-button.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>4. Open a web browser</h3> \n<p>Open a web browser to complete your set up.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          }
        ],
        "bannedComponents": [
          "in-page-nav",
          "tabs"
        ],
        "newData": {}
      },
      {
        "inputs": {
          "title": "Windows Vista"
        },
        "blocks": [
          {
            "inputs": {
              "contents": "<h3>1. Find wireless networks</h3> \n<p>Click the window icon, then select Connect To.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-vista-find-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>2. Select your wireless network</h3> \n<p>Your Sky Hub’s wireless details should appear in the list of networks. You'll find the name of your wireless network on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>If you don’t see your network name, click the <strong>Refresh network</strong> button.</p> \n<p>Select your network and click <strong>Connect</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-vista-select-your-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>3. Enter your wireless password</h3> \n<p>You’ll then be prompted to push the WPS (Wi-Fi Protected Setup) button on your Sky Hub or click the link to enter the password.</p> \n<p>The Network Key is your password. This can be found on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Enter your password in capital letters and click <strong>OK</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-vista-enter-your-wireless-password.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<p>If you are asked for a PIN then insert this instead of the password and click <strong>OK</strong>.</p> \n<p><strong>OR</strong></p> \n<p>Push the <strong>WPS button</strong> (Wi-Fi Protected Setup) and hold it in for two seconds. The wireless icon will flash amber.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/black-sky-hub-amber-wps-button.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>4. Open a web browser</h3> \n<p>Open a web browser to complete your set up.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          }
        ],
        "bannedComponents": [
          "in-page-nav",
          "tabs"
        ],
        "newData": {}
      },
      {
        "inputs": {
          "title": "Windows XP"
        },
        "blocks": [
          {
            "inputs": {
              "contents": "<h3>1. Find wireless networks</h3> \n<p>Right click the wireless icon then click View Available Wireless Networks.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-xp-find-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>2. Select your wireless network</h3> \n<p>Highlight your Sky Hub’s wireless details from the list.</p> \n<p>Your Sky Hub’s wireless details should appear in the list of networks. You'll find the name of your wireless network on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>If you don’t see your network name, click <strong>Refresh network</strong>.</p> \n<p>Select your network and click <strong>Connect</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-xp-select-wireless-network.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>3. Enter your wireless password</h3> \n<p>The Network Key is your password. This can be found on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Enter your password in capital letters and click <strong>Connect</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/windows-xp-enter-your-wireless-password.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>4. Open a web browser</h3> \n<p>Open a web browser to complete your set up.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          }
        ],
        "bannedComponents": [
          "in-page-nav",
          "tabs"
        ],
        "newData": {}
      },
      {
        "inputs": {
          "title": "Mac OSX"
        },
        "blocks": [
          {
            "inputs": {
              "contents": "<h3>1. Find wireless networks</h3> \n<p>Click on the Apple icon, select <strong>System Preferences</strong> and then click <strong>Network</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/mac-find-wireless-networks.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>2. Turn Airport on</h3> \n<p>Select <strong>Airport</strong> and click <strong>On</strong>.</p> \n<p>Your Sky Hub’s wireless details should appear in the list of networks. You'll find the name of your wireless network on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Select your network and click <strong>Connect</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/mac-wireless-turn-airport-on.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>3. Enter your wireless password</h3> \n<p>This can be found on the inside lid of your Sky Hub packaging, on the Connect card or the Keep me handy card. This is also on the back of your Sky Hub or Sky router.</p> \n<p>Enter your password in capital letters and click <strong>OK</strong>.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          },
          {
            "inputs": {
              "src": "http://prod-help-sky-com.s3.amazonaws.com/uploads/mac-enter-wireless-password.jpg"
            },
            "component": {
              "name": "Image",
              "inputs": [
                {
                  "src": "template"
                }
              ],
              "template": "image",
              "type": "element"
            }
          },
          {
            "inputs": {
              "contents": "<h3>4. Open a web browser</h3> \n<p>Open a web browser to complete your set up.</p>"
            },
            "component": {
              "name": "Text",
              "inputs": [
                {
                  "contents": "html"
                }
              ],
              "template": "text",
              "type": "element"
            }
          }
        ],
        "bannedComponents": [
          "in-page-nav",
          "tabs"
        ],
        "newData": {}
      }
    ],
    "bannedComponents": [
      "in-page-nav",
      "tabs"
    ],
    "newData": {}
  },
  {
    "inputs": {
      "contents": "<h3>Can’t get connected?</h3> <ul class=\"grey-bullets\"> <li>Have you turned on the wireless switch or button on your computer?</li> <li>Have you selected the correct network?</li> <li>Try entering your Password or PIN again</li> </ul>"
    },
    "component": {
      "name": "Text",
      "inputs": [
        {
          "contents": "html"
        }
      ],
      "template": "text",
      "type": "element"
    }
  }
]