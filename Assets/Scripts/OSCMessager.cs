using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using OscJack;

public class OSCMessager : MonoBehaviour
{
    readonly OscClient client = new("127.0.0.1", 57120);
    private Dictionary<KeyCode, int> keyToMidi = new()
    {
        { KeyCode.A, 60},
        { KeyCode.W, 61},
        { KeyCode.S, 62},
        { KeyCode.E, 63},
        { KeyCode.D, 64},
        { KeyCode.F, 65},
        { KeyCode.T, 66},
        { KeyCode.G, 67},
        { KeyCode.Y, 68},
        { KeyCode.H, 69},
        { KeyCode.U, 70},
        { KeyCode.J, 71},
        { KeyCode.K, 72},
    };

    // Start is called before the first frame update
    void Start()
    {
        //StartCoroutine(Test());
        client.Send("/panic");
    }

    // Update is called once per frame
    void Update()
    {
        foreach (KeyValuePair<KeyCode,int> entry in keyToMidi)
        {
            if (Input.GetKeyDown(entry.Key))
            {
                // IP address, port number
                client.Send("/on",       // OSC address
                            entry.Value); // First element
            }
            if (Input.GetKeyUp(entry.Key))
            {
                // IP address, port number
                client.Send("/off",       // OSC address
                            entry.Value); // First element
            }
        }

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            client.Send("/panic");
        }
    }

    /*IEnumerator Test()
    {
        using var client = new OscClient("127.0.0.1", 57120);
        

        while (true)
        {
            float note = Random.Range(50, 80);
            yield return new WaitForSeconds(0.5f);
            
            client.Send("/on",       // OSC address
                        note); // First element

            yield return new WaitForSeconds(0.5f);

            client.Send("/off",       // OSC address
                        note); // Second element
        }
    }*/


}
