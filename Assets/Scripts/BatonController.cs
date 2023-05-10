using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class BatonController : MonoBehaviour
{
    [SerializeField] GameObject TopPoint;
    [SerializeField] GameObject BottomPoint;
    [SerializeField] Slider TopXSlider, TopYSlider, TopZSlider;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Assign the position of the top empty object of the baton to the sliders
        (TopXSlider.value, TopYSlider.value, TopZSlider.value) = (TopPoint.transform.position.x, TopPoint.transform.position.y, TopPoint.transform.position.z);
    }
}
