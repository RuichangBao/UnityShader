using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Discard2 : MonoBehaviour
{
    public RawImage rawImage;
    public Material material;
    public float _CircleCenterX;
    public float _CircleCenterY;
    void Start()
    {
        rawImage = this.GetComponent<RawImage>();
        material = rawImage.material;
    }

    // Update is called once per frame
    void Update()
    {
        material.SetFloat("_CircleCenterX", _CircleCenterX / 100f);
        material.SetFloat("_CircleCenterY", _CircleCenterY / 100f);
    }
}
