using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < 10; i++)
        {
            for (int j = 0; j < 3; j++)
            {
                if (j == 1)
                    break;
                Debug.LogError("111111    " + j);
            }
            Debug.LogError("22222" + i);
        }
    }
    // Update is called once per frame
    void Update()
    {
    }
}

