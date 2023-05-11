using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;
using OscJack;

public class BatonController : MonoBehaviour
{
    [SerializeField] GameObject TopPoint;
    [SerializeField] GameObject BottomPoint;
    [SerializeField] Slider TopXSlider, TopYSlider, TopZSlider;

    [SerializeField] GameObject[] Keys;

    //OSC
    readonly OscClient client = new("127.0.0.1", 57121);

    // Start is called before the first frame update
    void Start()
    {
        client.Send("/panic");
    }

    // Update is called once per frame
    void Update()
    {
        //Assign the position of the top empty object of the baton to the sliders
        //(TopXSlider.value, TopYSlider.value, TopZSlider.value) = (TopPoint.transform.position.x, TopPoint.transform.position.y, TopPoint.transform.position.z);

        //If top point has moved, send OSC
        if (TopPoint.transform.hasChanged)
        {
            client.Send("/pan", Remap(TopPoint.transform.position.x, -3f, 3f, -1f, 1f));
            client.Send("/oscfreq", Remap(TopPoint.transform.position.z, -1f, 1f, 20f, 20000f));
            client.Send("/vib", Remap(TopPoint.transform.position.y, 0f, 2f, 0f, 30f));
        }
    }

    public void KeyboardTouch(int note)
    {
        client.Send("/on", note);
    }

    public void KeyboardRelease(int note)
    {
        client.Send("/off", note);
    }

    float Remap(float source, float sourceFrom, float sourceTo, float targetFrom, float targetTo)
    {
        return targetFrom + (source - sourceFrom) * (targetTo - targetFrom) / (sourceTo - sourceFrom);
    }
}
