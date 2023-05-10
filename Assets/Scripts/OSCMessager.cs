using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using OscJack;

public class OSCMessager : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.C))
        {
            // IP address, port number
            using var client = new OscClient("127.0.0.1", 57120);
            client.Send("/on",       // OSC address
                        60); // Second element
        }

        if (Input.GetKeyUp(KeyCode.C))
        {
            // IP address, port number
            using var client = new OscClient("127.0.0.1", 57120);
            client.Send("/off",       // OSC address
                        60); // First element
        }
    }


}
