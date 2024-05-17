using UnityEngine;

public class MotionBlurWithDepthTexture : PostEffectsBase
{
    public Shader motionBlurShader;
    private Material motionBlurMaterial;
    public Material material
    {
        get
        {
            motionBlurMaterial = CheckShaderAndCreateMaterial(motionBlurShader, motionBlurMaterial);
            return motionBlurMaterial;
        }
    }

    [Range(0, 1)]
    public float blurSize = 0.5f;

    private Camera myCamera;
    public Camera camera
    {
        get
        {
            if (myCamera == null)
                myCamera = GetComponent<Camera>();
            return myCamera;
        }
    }
    //��һ֡����ͼͶӰ����
    private Matrix4x4 previousViewProjectionMatrix;

    private void OnEnable()
    {
        camera.depthTextureMode |= DepthTextureMode.Depth;//��ȡ�������
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material == null)
        {
            Graphics.Blit(source, destination);
            return;
        }
        material.SetFloat("_BlurSize", blurSize);
        material.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
        //camera.projectionMatrix ͶӰ���󣬽������۲�ռ�任���ü��ռ�
        //camera.worldToCameraMatrix ��ͼ���� �����������ռ�任���۲�ռ䡣
        Matrix4x4 currentViewProjectionMatrix = camera.projectionMatrix * camera.worldToCameraMatrix;
        //�Ӳü��ռ�任������ռ�ľ���
        Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;
        material.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
        previousViewProjectionMatrix = currentViewProjectionMatrix;
        Graphics.Blit(source, destination, material);
    }
}